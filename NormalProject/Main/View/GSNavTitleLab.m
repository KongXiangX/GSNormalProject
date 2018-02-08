//
//  GSNavTitleLab.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "GSNavTitleLab.h"
#import "NSString+GS.h"   //
@implementation GSNavTitleLab

+ (instancetype)defaultNavTitleLabWithTitle:(NSString *)title
{
    GSNavTitleLab *label = [[GSNavTitleLab alloc] init];
    label.text = title;
    return label;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self basicSetting];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self basicSetting];
    }
    return self;
}

// 基本设置
- (void)basicSetting
{
    CGFloat navBackItemW = 50; //左右 两侧item 的 宽
    
    self.frame = CGRectMake(0, 0, GSScreenW - navBackItemW*2, GSNavMaxY - GSStatusBarH);
    self.font = GSNavTitleFont;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor whiteColor];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];

}


@end
