//
//  UIImage+GSCutScreen.h
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GSCutScreen)
+ (UIImage *)lf_cutScreen;
+ (UIImage *)cutFromView:(UIView *)view;
@end
