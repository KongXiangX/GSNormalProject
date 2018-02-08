//
//  NSString+GS.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "NSString+GS.h"
//#import "LFNSData+Add.h"
//#import "LFNSNumber+Add.h"
//#import "LFNSCharacterSet+Add.h"
//#import "LFCategoryMacro.h"
/**
 Ceil the size (for string drawing calculate)
 */
static inline CGSize CGSizeCeil(CGSize size) {
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

static BOOL g_allowedCharacters = NO;
static BOOL g_stringByRemovingPercentEncoding = NO;

@implementation NSString (GS)

- (NSString *)lf_stringByURLEncode {
    return [self lf_stringByURLEncode:NSUTF8StringEncoding];
}

- (NSString *)lf_stringByURLDecode {
    return [self lf_stringByURLDecode:NSUTF8StringEncoding];
}

- (NSString *)lf_stringByURLEncode:(NSStringEncoding)encoding {
    
    static NSString * const  allowedCharacters = @"!*'();:@&=+$,/?%#[]";
    g_allowedCharacters = [NSString instancesRespondToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)];
    if (g_allowedCharacters) {
        static NSCharacterSet * characterSet = nil;
        if (characterSet == nil) {
            characterSet = [NSCharacterSet characterSetWithCharactersInString:allowedCharacters];
        }
        return  [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    } else {
        CFStringRef escaped = NULL;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        escaped = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                          (CFStringRef)self,
                                                          NULL,
                                                          (CFStringRef)allowedCharacters,
                                                          (CFStringEncoding)encoding);
#pragma clang diagnostic pop
        
#if defined(__has_feature) && __has_feature(objc_arc)
        return CFBridgingRelease(escaped);
#else
        return [(NSString *)escaped autorelease];
#endif
    }
}

- (NSString *)lf_stringByURLDecode:(NSStringEncoding)encoding {
    
    g_stringByRemovingPercentEncoding = [NSString instancesRespondToSelector:@selector(stringByRemovingPercentEncoding)];
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    
    
    if (g_stringByRemovingPercentEncoding) {
        return resultString.stringByRemovingPercentEncoding;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [resultString stringByReplacingPercentEscapesUsingEncoding:encoding];
#pragma clang diagnostic pop
    }
}

- (NSString *)lf_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

- (CGSize)lf_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = @{}.mutableCopy;
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeCeil(result);
}

- (CGFloat)lf_widthForFont:(UIFont *)font {
    CGSize size = [self lf_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)lf_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self lf_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGFloat)heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width {
    CGFloat height;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{ NSFontAttributeName: font } context:nil];
        height = rect.size.height;
        height += 1;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        height = size.height;
    }
    return height;
}

- (CGFloat)lf_heightForFont:(UIFont *)font width:(CGFloat)width line:(NSInteger)line {
    NSMutableString *test = NSMutableString.new;
    for (int i=0; i<line; i++) {
        [test appendString:@"字"];
    }
    CGFloat maxHeight = [self heightForString:test font:font width:1];
    CGFloat height = [self heightForString:self font:font width:width];
    return height > maxHeight ? maxHeight : height;
}




+ (NSString *)lf_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)lf_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}



- (BOOL)lf_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}



- (BOOL)lf_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}


- (NSData *)lf_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}



- (NSString *)lf_stringNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return str;
}

- (NSString *)lf_segmentString {
    NSMutableString *str = [NSMutableString stringWithString:self];
    NSInteger count = floorf((CGFloat)self.length / 3);
    if (self.length % 3 == 0) {
        count = floorf((CGFloat)self.length / 3) - 1;
    }
    for (int i = 0; i < count; i ++) {
        [str insertString:@"," atIndex: (str.length - (3*(i + 1) + i))];
    }
    
    return str;
}
@end
