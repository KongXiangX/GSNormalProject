//
//  GSWebVC.m
//  NormalProject
//
//  Created by apple on 2017/12/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "GSWebVC.h"
#import "HZYRoundShowButton.h"          //按钮

@interface GSWebVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
//1.web
@property (nonatomic, strong) UIWebView * web;         //webView
//断网提示
@property (nonatomic, strong) UIView * noNetView;
@property (nonatomic, strong) NSURLRequest * webUrlRequest;

//2.进度条
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation GSWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //0.
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = GSColor(230, 230, 230);
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    
    //1. 初始化web
    [self.view addSubview:self.web];
    
    
    //2.更换网址
    [self loadWebUrl];
    
    //3.手势 与 进度条
    [self setupGestureAndProgress];
    
    //4.设置 悬浮 按钮
    [self setupTouchBtn];
    
    //5.断网 提示
    [self setupNoNetView];
    
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

#pragma mark - 0.设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


#pragma mark - 1.初始化web
- (UIWebView *)web
{
    if (_web == nil) {
        CGFloat webY = 0;
        if ([self.navigationController.navigationBar isHidden]) {
            webY = (SYSTEM_VERSION < 11.0) ? 0 :GSStatusBarH;
        }else{
            webY = (SYSTEM_VERSION < 11.0) ? 0 :GSNavMaxY;
        }
        
        
        _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, webY, GSScreenW, GSScreenH - GSTabbarSafeBottomMargin - webY)];
        if (@available(iOS 11.0, *)) {
            _web.scrollView.contentInsetAdjustmentBehavior = iPhoneX ? UIScrollViewContentInsetAdjustmentAlways : UIScrollViewContentInsetAdjustmentNever;
        }
        _web.scalesPageToFit = YES;//自动  缩放 适配 手机屏幕
        _web.delegate = self;
        _web.scrollView.delegate = self;
        _web.allowsInlineMediaPlayback = YES;
        _web.mediaPlaybackRequiresUserAction = YES;
        _web.mediaPlaybackAllowsAirPlay = YES;
        _web.suppressesIncrementalRendering = YES;
    }
    return _web;
}

#pragma mark -- 1.1  UIWebViewDelegate
// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    self.noNetView.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == -999  ) {
        return;
    }
    
    //断网提示
    self.noNetView.hidden = NO;
    [SVProgressHUD showErrorWithStatus:@"加载失败！"];
    [SVProgressHUD dismissWithDelay:1.5f];
}



#pragma mark - 2. 加载网址
- (void)loadWebUrl
{
    //1.
    NSURL * webUrl = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest * webUrlRequest = [NSURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.web loadRequest:webUrlRequest];
    self.webUrlRequest = webUrlRequest;
}

#pragma mark - 3. 手势 与 进度条
- (void)setupGestureAndProgress
{
    //1.1.左扫 手势
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(webGoOrBack:)];
    //默认是UISwipeGestureRecognizerDirectionRight
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.web addGestureRecognizer:swipe];
    
    //1.2 右扫 手势
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(webGoOrBack:)];
    //默认是UISwipeGestureRecognizerDirectionRight
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.web addGestureRecognizer:swiperight];
    
    //2.创建进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.web.frame.origin.y, GSScreenW, 2.0)];
    progressView.tintColor = [UIColor blueColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
}


#pragma mark -- 3.1.左右 滑 手势
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


#pragma mark - 4.设置 悬浮 按钮
- (void)setupTouchBtn
{
    
    CGFloat btnH = 38;
    CGFloat btnW = btnH*49/42.0;
    
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn1 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"ico_qianjin"] forState:UIControlStateNormal];
    
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn2 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn3 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"ico_refresh"] forState:UIControlStateNormal];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btn4 addTarget:self action:@selector(roundShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"ico_home"] forState:UIControlStateNormal];
    
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



- (void)roundShowClick:(UIButton *)btn{
    
    [self.web stopLoading];
    self.loadCount = 0;
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


#pragma mark - 5 .断网提示
- (void)setupNoNetView
{
    //1.bg
    UIView * noNetView = [[UIView alloc] initWithFrame:self.web.frame];
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
    self.loadCount = 0;
    [self loadWebUrl];
}

#pragma mark - 6. 清除缓存
- (void)deleteWebCache {
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (id cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //清除请求
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:self.webUrlRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self deleteWebCache];
}


@end
