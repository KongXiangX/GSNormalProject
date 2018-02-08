
//
//  GSTabBarVC.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "GSTabBarVC.h"
#import "GSTabBar.h"

#import "GSNavigationVC.h"

#import "ViewController01.h"    //主页
#import "ViewController02.h"    //美食
#import "ViewController03.h"    //我的
@interface GSTabBarVC ()

@end

@implementation GSTabBarVC

+(void)initialize
{
    UITabBarItem *appearance = [UITabBarItem appearance];
    //设置tabbarItem 的文字与颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:attrs forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置TabBar 背景色
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    GSLog(@"bgViewHZ----%lf",bgView.gs_height);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreenW, GSTabBarH)];
    bgView.backgroundColor = [UIColor purpleColor];
    [[GSTabBar appearance]insertSubview:bgView atIndex:0];
    
    // 2.初始化所有的子控制器
    [self setupChildViewControllers];
    
    // 3.自定义tabBar
    [self setupTabBar];
}

#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    GSTabBar *tabBar = [[GSTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}

/**
 * 初始化所有的子控制器
 */
-(void)setupChildViewControllers
{
    //1.主页
    ViewController01 * homeVC = [[ViewController01 alloc]init];
    [self setupOneChildViewController:homeVC title:@"主页" image:@"11" selectedImage:@"11"];
    
    //2.美食
    ViewController02 * cateVC = [[ViewController02 alloc]init];
    [self setupOneChildViewController:cateVC title:@"美食" image:@"11" selectedImage:@"11"];
    
    //3.我的
    ViewController03 * meVC = [[ViewController03 alloc]init];
    [self setupOneChildViewController:meVC title:@"我的" image:@"11" selectedImage:@"11"];
    
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置tabbarItem 文字的位置
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(-5,-5);
    if (iPhoneX) {
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0);
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-35);
    }
    

    [self addChildViewController:[[GSNavigationVC alloc] initWithRootViewController:vc]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
