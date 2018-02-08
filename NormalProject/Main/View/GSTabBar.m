//
//  GSTabBar.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "GSTabBar.h"

@interface GSTabBar()
/** 上一次点击的按钮 */
@property (nonatomic, weak) UIControl *previousClickedTabBarButton;
@end


@implementation GSTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
   
    // 跳转tabBarButton位置
    NSInteger count = self.items.count;
    
    CGFloat btnW = self.gs_width / count;
    CGFloat btnH = self.gs_height;
    CGFloat x = 0;
    int i = 0;
    // 私有类:打印出来有个类,但是敲出来没有,说明这个类是系统私有类
    // 遍历子控件 调整布局
    for (UIControl *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 设置previousClickedTabBarButton默认值为最前面的按钮
            if (i == 0 && self.previousClickedTabBarButton == nil) {
                self.previousClickedTabBarButton = tabBarButton;
            }
            
            x = i * btnW;
            
            tabBarButton.frame = CGRectMake(x, 0, btnW, btnH);
            
            i++;
            
            // UIControlEventTouchDownRepeat : 在短时间内连续点击按钮
            
            // 监听点击
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

/**
 *  tabBarButton的点击
 */
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    if (self.previousClickedTabBarButton == tabBarButton) {
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:GSTabBarButtonDidRepeatClickNotification object:nil];
    }
    
    self.previousClickedTabBarButton = tabBarButton;
}


- (void)setFrame:(CGRect)frame {
    if (iPhoneX) {
        if (frame.origin.y < ([UIScreen mainScreen].bounds.size.height - 83)) {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - 83;
        }
    }
    [super setFrame: frame];
}


@end
