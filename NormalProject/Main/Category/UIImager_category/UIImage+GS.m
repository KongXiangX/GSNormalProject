//
//  UIImage+GS.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "UIImage+GS.h"
#import "NSString+GS.h"

#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

#ifndef LF_SWAP
#define LF_SWAP(a, b)  do { __typeof__(a) _tmp_ = (a); (a) = (b); (b) = _tmp_; } while (0)
#endif

@implementation UIImage (GS)
#pragma mark - 图像拉伸

- (UIImage *)lf_stretchableImageWithCenter
{
    return [self stretchableImageWithLeftCapWidth:self.size.width/2.f
                                     topCapHeight:self.size.height/2.f];
}

CGImageRef CGImageCreateDecoded(CGImageRef imageRef) {
    if (!imageRef) return nil;
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect rect = { CGPointZero, size };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t colorChannels = CGColorSpaceGetNumberOfComponents(colorSpace);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    CGImageAlphaInfo alphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
    BOOL hasAlpha = alphaInfo != kCGImageAlphaNone &&
    alphaInfo != kCGImageAlphaNoneSkipFirst &&
    alphaInfo != kCGImageAlphaNoneSkipLast;
    
    if (alphaInfo == kCGImageAlphaNone && colorChannels > 1) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    } else if (hasAlpha && colorChannels == 3) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, CGImageGetBitsPerComponent(imageRef), 0, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (!context) return (CGImageRef)CFRetain(imageRef);
    
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    if (!newImageRef) return (CGImageRef)CFRetain(imageRef); //某些特殊格式的图片在某些环境下可能解码失败...返回原图让UIImage来尝试显示吧
    return newImageRef;
}

static NSTimeInterval _lf_CGImageSourceGetGIFFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    // http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    if (delay < 0.02) delay = 0.1;
    return delay;
}

- (BOOL)isImageDecoded {
    if (self.images.count > 1) return YES;
    NSNumber *num = objc_getAssociatedObject(self, @selector(isImageDecoded));
    return [num boolValue];
}

- (void)setIsImageDecoded:(BOOL)decoded {
    objc_setAssociatedObject(self, @selector(isImageDecoded), @(decoded), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)lf_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [self.class imageWithData:data scale:scale];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = _lf_CGImageSourceGetGIFFrameDelayAtIndex(source, i);
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = @[].mutableCopy;
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        CGImageRef decoded = CGImageCreateDecoded(imageRef);
        CGImageRelease(imageRef);
        UIImage *image = [UIImage imageWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(decoded);
        if (image) {
            for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
                [array addObject:image];
            }
        }
    }
    CFRelease(source);
    UIImage *image = [self.class animatedImageWithImages:array duration:totalTime];
    return image;
}
+ (BOOL)lf_isAnimatedGIFData:(NSData *)data {
    if (!data || data.length < 16) return NO;
    UInt32 magic = *(UInt32 *)data.bytes;
    if ((magic & 0xFFFFFF) != '\0FIG') return NO; // http://www.w3.org/Graphics/GIF/spec-gif89a.txt
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
    if (!source) return NO;
    size_t count = CGImageSourceGetCount(source);
    CFRelease(source);
    return count > 1;
}

+ (UIImage *)lf_imageWithPDF:(id)dataOrPath {
    return [self _lf_imageWithPDF:dataOrPath resize:NO size:CGSizeZero];
}

+ (UIImage *)lf_imageWithPDF:(id)dataOrPath size:(CGSize)size {
    return [self _lf_imageWithPDF:dataOrPath resize:YES size:size];
}


+ (UIImage *)lf_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)_lf_imageWithPDF:(id)dataOrPath resize:(BOOL)resize size:(CGSize)size {
    CGPDFDocumentRef pdf = NULL;
    if ([dataOrPath isKindOfClass:[NSData class]]) {
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)dataOrPath);
        pdf = CGPDFDocumentCreateWithProvider(provider);
        CGDataProviderRelease(provider);
    } else if ([dataOrPath isKindOfClass:[NSString class]]) {
        pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL URLWithString:dataOrPath]);
    }
    if (!pdf) return nil;
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    if (!page) {
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGRect pdfRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGSize pdfSize = resize ? size : pdfRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, pdfSize.width * scale, pdfSize.height * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (!ctx) {
        CGColorSpaceRelease(colorSpace);
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, -pdfRect.origin.x, -pdfRect.origin.y);
    CGContextDrawPDFPage(ctx, page);
    CGPDFDocumentRelease(pdf);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    UIImage *pdfImage = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    pdfImage.isImageDecoded = YES;
    return pdfImage;
}

+ (UIImage *)lf_imageWithColor:(UIColor *)color {
    return [self lf_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)lf_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIColor *)lf_colorAtPoint:(CGPoint)point {
    if (point.x < 0 || point.y < 0) return nil;
    
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) return nil;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x * self.scale >= width || point.y * self.scale >= height) return nil;
    
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData) return nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    long byteIndex = (long)(point.y * self.scale * bytesPerRow) + (long)(point.x * self.scale * bytesPerPixel);
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return color;
}

- (BOOL)lf_hasAlphaChannel {
    if (self.CGImage == NULL) return NO;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


- (UIImage *)lf_imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)lf_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self lf_drawInRect:CGRectMake(0, 0, size.width, size.height) withContentMode:contentMode clipsToBounds:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)lf_imageByCropToRect:(CGRect)rect {
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)lf_imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color {
    CGSize size = self.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(-insets.left, -insets.top, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)lf_imageByRoundCornerRadius:(CGFloat)radius {
    return [self lf_imageByRoundCornerRadius:radius corners:UIRectCornerAllCorners borderWidth:0];
}

- (UIImage *)lf_imageByRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)] addClip];
        CGContextDrawImage(context, rect, self.CGImage);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)lf_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)_lf_flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

- (UIImage *)lf_imageByRotateLeft90 {
    return [self lf_imageByRotate:DegreesToRadians(90) fitSize:YES];
}

- (UIImage *)lf_imageByRotateRight90 {
    return [self lf_imageByRotate:DegreesToRadians(-90) fitSize:YES];
}

- (UIImage *)lf_imageByRotate180 {
    return [self _lf_flipHorizontal:YES vertical:YES];
}

- (UIImage *)lf_imageByFlipVertical {
    return [self _lf_flipHorizontal:NO vertical:YES];
}

- (UIImage *)lf_imageByFlipHorizontal {
    return [self _lf_flipHorizontal:YES vertical:NO];
}
- (void)lf_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode  clipsToBounds:(BOOL)clips{
    CGRect drawRect;
    CGSize size = self.size;
    switch (contentMode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill: {
            [self drawInRect:rect];
            return;
        }
        case UIViewContentModeScaleAspectFit: {
            CGFloat factor;
            if (size.width < size.height) {
                factor = rect.size.height / size.height;
            } else {
                factor = rect.size.width / size.width;
            }
            size.width *= factor;
            size.height *= factor;
            drawRect = CGRectMake(CGRectGetMidX(rect) - size.width * 0.5,
                                  CGRectGetMidY(rect) - size.height * 0.5,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeScaleAspectFill: {
            CGFloat factor;
            if (size.width < size.height) {
                factor = rect.size.width / size.width;
            } else {
                factor = rect.size.height / size.height;
            }
            size.width *= factor;
            size.height *= factor;
            drawRect = CGRectMake(CGRectGetMidX(rect) - size.width * 0.5,
                                  CGRectGetMidY(rect) - size.height * 0.5,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeCenter: {
            drawRect = CGRectMake(CGRectGetMidX(rect) - size.width * 0.5,
                                  CGRectGetMidY(rect) - size.height * 0.5,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeTop: {
            drawRect = CGRectMake(CGRectGetMidX(rect) - size.width * 0.5,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeBottom: {
            drawRect = CGRectMake(CGRectGetMidX(rect) - size.width * 0.5,
                                  rect.origin.y + rect.size.height - size.height,
                                  size.width,
                                  size.height);
        }  break;
            
        case UIViewContentModeLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMidY(rect) - size.height * 0.5,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  CGRectGetMidY(rect) - size.height * 0.5,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeTopLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeTopRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeBottomLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
        } break;
            
        case UIViewContentModeBottomRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
        } break;
        default: return;
    }
    
    if (clips) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) {
            CGContextSaveGState(context);
            CGContextAddRect(context, rect);
            CGContextClip(context);
            [self drawInRect:drawRect];
            CGContextRestoreGState(context);
        }
    } else {
        [self drawInRect:drawRect];
    }
}


@end
