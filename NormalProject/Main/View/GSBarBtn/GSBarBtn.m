//
//  GSBarBtn.m
//  GSHX
//
//  Created by apple on 2018/1/25.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSBarBtn.h"

#define BarBtnFont [UIFont boldSystemFontOfSize:13]  //字体大小

@implementation GSBarBtn
//返回按钮 （有nav）
+ (instancetype)defaultBarBackBtnWithAction:(SEL)action
{
    GSBarBtn * barBtn = [[GSBarBtn alloc] initWithFrame:CGRectMake(0, 0, 25,46)];
    [barBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [barBtn addTarget:[barBtn getCurrentVC] action:action forControlEvents:UIControlEventTouchUpInside];
    return barBtn;
}
//返回按钮 （有nav）
+ (instancetype)defaultBarBackBtnWithViewController:(UIViewController *)vc action:(SEL)action
{
    GSBarBtn * barBtn = [[GSBarBtn alloc] initWithFrame:CGRectMake(0, 0, 25,46)];
    [barBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [barBtn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    return barBtn;
}

//自定义barItem -- title(2个文字)  （按钮）
+ (instancetype)defaultBarBtnWithTitle:(NSString *)title action:(SEL)action
{
    CGFloat barBtnW = [title lf_widthForFont:BarBtnFont] + 10;
    GSBarBtn * barBtn = [[GSBarBtn alloc] initWithFrame:CGRectMake(0, 0, barBtnW, GSNavMaxY - GSStatusBarH)];
    [barBtn setTitle:title forState:UIControlStateNormal];
    [barBtn addTarget:[barBtn getCurrentVC] action:action forControlEvents:UIControlEventTouchUpInside];
    return barBtn;
}

//自定义barItem -- img(图片30*30pt)  （按钮）
+ (instancetype)defaultBarBtnWithImageNamed:(NSString *)imgStr action:(SEL)action
{
    
    GSBarBtn * barBtn = [[GSBarBtn alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [barBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [barBtn addTarget:[barBtn getCurrentVC] action:action forControlEvents:UIControlEventTouchUpInside];
    return barBtn;
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
    self.backgroundColor = [UIColor redColor];
    
    self.titleLabel.font = BarBtnFont;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

#pragma mark - 获取当前 VC
//https://www.jianshu.com/p/949fd3dd720b  参考
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
