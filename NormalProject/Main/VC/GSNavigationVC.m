//
//  GSNavigationVC.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "GSNavigationVC.h"

@interface GSNavigationVC ()<UIGestureRecognizerDelegate>

@end

@implementation GSNavigationVC
+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 只要是通过模型设置,都是通过富文本设置
    // 设置导航条标题 => UINavigationBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navItem_background"] forBarMetrics:UIBarMetricsDefault];
    
}
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navItem_background"] forBarMetrics:UIBarMetricsDefault];
    //    bar.backgroundColor = [UIColor blueColor];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:16]}];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) {// 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置返回按钮,只有非根控制器
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navItem_back"] forState:UIControlStateNormal];
        //        [button setImage:[UIImage imageNamed:@"navItem_back"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(-10, 0, 40, 40);
        
        //        [button setBackgroundColor:[UIColor redColor]];
        //把UIButton 包装秤UI把人ButtonItem 就导致按钮点击区域扩大。
        // 解决方法  创建Button -- ([leftBtn sizeToFit];) --- 创建一个View并且作为btn 的父视图 -- 把View放入self.navigationItem.leftBarButtonItem
        UIView * containView = [[UIView alloc] initWithFrame:button.bounds];
        [containView addSubview:button];
        UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:containView];
        viewController.navigationItem.leftBarButtonItem = leftBarBtn;
        
    }
    // 真正在跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    
    [self popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
