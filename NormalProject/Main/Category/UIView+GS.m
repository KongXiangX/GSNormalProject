//
//  UIView+GS.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "UIView+GS.h"

@implementation UIView (GS)
//1.gs_x
- (void)setGs_x:(CGFloat)gs_x
{
    CGRect frame = self.frame;
    frame.origin.x = gs_x;
    self.frame = frame;
}
- (CGFloat)gs_x
{
    return self.frame.origin.x;
}

//2.gs_y
-(void)setGs_y:(CGFloat)gs_y
{
    CGRect frame = self.frame;
    frame.origin.y = gs_y;
    self.frame = frame;
}
-(CGFloat)gs_y
{
    return self.frame.origin.y;
}

//3.gs_centerX
- (void)setGs_centerX:(CGFloat)gs_centerX
{
    CGPoint center = self.center;
    center.x = gs_centerX;
    self.center = center;
}

- (CGFloat)gs_centerX
{
    return self.center.x;
}

//4.gs_centerY
- (void)setGs_centerY:(CGFloat)gs_centerY
{
    CGPoint center = self.center;
    center.y = gs_centerY;
    self.center = center;
}

- (CGFloat)gs_centerY
{
    return self.center.y;
}
//5.gs_with
- (void)setGs_width:(CGFloat)gs_width
{
    CGRect frame = self.frame;
    frame.size.width = gs_width;
    self.frame = frame;
}

- (CGFloat)gs_width
{
    return self.frame.size.width;
}
//6.gs_height
- (void)setGs_height:(CGFloat)gs_height
{
    CGRect frame = self.frame;
    frame.size.height = gs_height;
    self.frame = frame;
}

- (CGFloat)gs_height
{
    return self.frame.size.height;
}

//7.gs_size
- (void)setGs_size:(CGSize)gs_size
{
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = gs_size;
    self.frame = frame;
}

- (CGSize)gs_size
{
    return self.frame.size;
}
@end
