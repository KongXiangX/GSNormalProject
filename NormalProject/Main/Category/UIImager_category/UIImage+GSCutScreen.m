//
//  UIImage+GSCutScreen.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "UIImage+GSCutScreen.h"

@implementation UIImage (GSCutScreen)
+ (UIImage *)lf_cutScreen{
    return [self cutFromView:[UIApplication sharedApplication].keyWindow];
}

+ (UIImage *)cutFromView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    [[UIColor clearColor] setFill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
    
}
@end
