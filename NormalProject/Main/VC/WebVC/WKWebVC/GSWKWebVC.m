//
//  GSWKWebVC.m
//  NormalProject
//
//  Created by apple on 2017/12/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "GSWKWebVC.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

#import "YHWebViewProgressView.h"
#import "HZYRoundShowButton.h"


@interface GSWKWebVC ()<WKUIDelegate, WKNavigationDelegate>
//1.web
@property (nonatomic, strong) WKWebView *web;

//断网提示
@property (nonatomic, strong)  UIView * noNetView;


@end

@implementation GSWKWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    
    //1. 初始化web
    [self.view addSubview:self.web];
    
    //2.更换网址
    [self loadWebUrl];
    
    //3.断网提示
    [self setupNoNetView];
    
    //4.1 设置 悬浮 按钮
    [self setupTouchBtn];
    
    //4.2 设置成 底部按钮
    [self setupBottomView];
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //1.隐藏弹框
    [SVProgressHUD popActivity];
    [self.web stopLoading];
    
    //2.清除缓存
    [self deleteWebCache];
    
}
#pragma mark - 0. 设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - 1.懒加载
- (WKWebView *)web
{
    if (_web == nil) {
        
        CGFloat webY = 0;
        if ([self.navigationController.navigationBar isHidden]) {
            webY = (SYSTEM_VERSION < 11.0) ? 0 : GSStatusBarH;
        }else{
            webY = (SYSTEM_VERSION < 11.0) ? 0 : GSNavMaxY;
        }
        
        _web = [[WKWebView alloc] initWithFrame:CGRectMake(0, webY, GSScreenW, GSScreenH - GSTabbarSafeBottomMargin - webY)];
        
        if (@available(iOS 11.0, *)) {
            _web.scrollView.contentInsetAdjustmentBehavior = iPhoneX ? UIScrollViewContentInsetAdjustmentAlways : UIScrollViewContentInsetAdjustmentNever;
        }
        _web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _web.scrollView.bounces = YES;
        _web.backgroundColor = GSColor(230, 230, 230);
        _web.navigationDelegate = self;
        
    }
    return _web;
}
#pragma mark --1.1 WKNavigationDelegate

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == -999  ) {
        return;
    }
    
    //1.提示
    [SVProgressHUD showErrorWithStatus:@"加载失败！"];
    [SVProgressHUD dismissWithDelay:1.0];
    
    //2.隐藏 断网提示
    self.noNetView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
    
    self.noNetView.hidden = YES;
}

#pragma mark -- 1.2清除缓存
- (void)deleteWebCache {
    
    if (@available (iOS 9.0 ,*)) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        //        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
    
}
#pragma mark - 2. 加载网址
- (void)loadWebUrl
{
    NSURL * webUrl = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest * webUrlRequest = [NSURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.web loadRequest:webUrlRequest];
    
    
    //2.创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.web.frame.origin.y, GSScreenW, 2.0)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    progressView.progressBarColor = GSColor(36, 179, 221);
    [progressView useWkWebView:self.web];
    
    // 添加到视图
    [self.view addSubview:progressView];
    
    
    //2.左扫 手势
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(webGoOrBack:)];
    //默认是UISwipeGestureRecognizerDirectionRight
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.web addGestureRecognizer:swipe];
    
    //3.右扫 手势
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(webGoOrBack:)];
    //默认是UISwipeGestureRecognizerDirectionRight
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.web addGestureRecognizer:swiperight];
}

#pragma mark --  2.1.goback
- (void)webGoOrBack:(UISwipeGestureRecognizer *)swip
{
    //1.右滑
    switch (swip.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            //2.左划
        {
            [self webGoForward];
            
        }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            //2.右划
        {
            [self webGoBack];
            
        }
            
            break;
            
        default:
            break;
    }
    
}

//返回上一页
- (void)webGoBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.web canGoBack]) {
            [self.web goBack];
        }
    });
}

//前进
- (void)webGoForward
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.web canGoForward]) {
            [self.web goForward];
        }
    });
}



#pragma mark - 3.断网提示
- (void)setupNoNetView
{
    //1.bg
    
    UIView * noNetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreenW, GSScreenH)];
    noNetView.hidden = YES;
    noNetView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noNetView];
    self.noNetView = noNetView;
    
    CGFloat noNetBtnY = (GSScreenH - GSNavMaxY)*0.5 - 50;
    //2.按钮
    UIButton * noNetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noNetBtn.frame = CGRectMake((GSScreenW - 150)*0.5, noNetBtnY, 150, 50);
    //    [noNetBtn setImage:[UIImage imageNamed:@"WebVVC_noNet"] forState:UIControlStateNormal];
    [noNetBtn setTitle:@"暂时链接不上服务器" forState:UIControlStateNormal];
    [noNetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    noNetBtn.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8];
    noNetBtn.layer.cornerRadius = 10;
    noNetBtn.layer.masksToBounds = YES;
    //        noNetBtn.backgroundColor = [UIColor redColor];
    noNetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [noNetBtn addTarget:self action:@selector(noNetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [noNetView addSubview:noNetBtn];
    
    
    //3.文字
    //    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, noNetBtnY + 50, GSScreenW, 40)];
    //    lab.font = [UIFont systemFontOfSize:15];
    //    lab.textColor = [UIColor blackColor];
    //    lab.numberOfLines = 2;
    //    lab.textAlignment = NSTextAlignmentCenter;
    ////    lab.text = @"暂时链接不上服务器\n点我刷新！";
    //    [noNetView addSubview:lab];
}
- (void)noNetBtnClick
{
    //1.最好不要使用 reload ，因为wk内部记录了这个网址（网址：本身错误不存在）的为失效网址，不会重新发送请求加载。所以不会再次弹出提示框 网络加载失败。最好使用NSURLRequest重新加载
    
    //    [self.web reload];
    
    //2.
    NSURL * webUrl = [NSURL URLWithString:@"https://baidu.com"];
    NSURLRequest * webUrlRequest = [NSURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.web loadRequest:webUrlRequest];
}

#pragma mark - 4.1 设置 悬浮 按钮
- (void)setupTouchBtn
{
    
    CGFloat btnH = 38;
    CGFloat btnW = btnH*49/42.0;
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn1 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setupBtnAttribute:btn1 withImgName:@"ico_qianjin"];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn2 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setupBtnAttribute:btn2 withImgName:@"ico_back"];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn3 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setupBtnAttribute:btn3 withImgName:@"ico_refresh"];
    
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn4 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setupBtnAttribute:btn4 withImgName:@"ico_home"];
    
    HZYRoundShowButton *roundBtn = [HZYRoundShowButton roundShowButton:@[btn1, btn2, btn3, btn4] andRadius:72 andSize:CGSizeMake(btnW, btnH) andPosition:CGPointMake(GSScreenW -btnH*0.5,(GSScreenH - btnH)*0.5)];
    roundBtn.arcLength = M_PI;
    roundBtn.startAngle = M_PI / 2 ;
    roundBtn.roundButton = YES;
    [self.view addSubview:roundBtn];
    
    btn1.tag = 1000;
    btn2.tag = 1001;
    btn3.tag = 1002;
    btn4.tag = 1003;
}


- (void)setupBtnAttribute:(UIButton*)btn withImgName:(NSString *)normalStr
{
    [btn setBackgroundImage:[UIImage imageNamed:normalStr] forState:UIControlStateNormal];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    //    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    btn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
}

- (void)roundShowClick:(UIButton *)btn{
    
    //1.前进
    if (btn.tag == 1000) {
        [self webGoForward];
    }
    
    //2.后退
    if (btn.tag == 1001) {
        [self webGoBack];
        
    }
    
    //3.刷新
    if (btn.tag == 1002) {
        [self.web reload];
    }
    
    //4.主页
    if (btn.tag == 1003) {
        [self loadWebUrl];
    }
}

#pragma mark - 4.2 底部 按钮
- (void)setupBottomView
{
    NSArray * imgs = @[@"ico_qianjin",@"ico_back",@"ico_refresh",@"ico_home"];
    CGFloat btnW = GSScreenW/imgs.count;
    CGFloat btnH = 45;
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, GSScreenH - btnH, GSScreenW, btnH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    for (int i = 0; i < imgs.count;  i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW*i, 0, btnW, btnH);
        [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(roundShowClick2:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
        btn.tag = 1004 + i;
    }
    
}
- (void)roundShowClick2:(UIButton *)btn{
    
    //1.前进
    if (btn.tag == 1004) {
        [self webGoForward];
    }
    
    //2.后退
    if (btn.tag == 1005) {
        [self webGoBack];
        
    }
    
    //3.刷新
    if (btn.tag == 1006) {
        [self.web reload];
    }
    
    //4.主页
    if (btn.tag == 1007) {
        [self loadWebUrl];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self deleteWebCache];
}


@end
