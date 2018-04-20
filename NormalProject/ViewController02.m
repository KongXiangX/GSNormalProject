//
//  ViewController02.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "ViewController02.h"
#import "GSCustomTableView.h"


@interface ViewController02 ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton * proviousBtn;
@property (nonatomic, assign) NSInteger  previousBtnTag;//上一个Btnd的tag
@property (nonatomic, assign) NSInteger nowBtnTag;
@property (nonatomic, weak  ) UIImageView * barImg;

@property (nonatomic, weak  ) UIScrollView * topScroll;
@property (nonatomic, weak  ) UIScrollView * bottomScroll;
@end

@implementation ViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //1.
    [self setupNav];
    
    //2.top
    [self setupTopView];

    //3.中间的scroll
    [self setupMiddleView];

   
    
}



#pragma mark - 1. nav
- (void)setupNav
{
    GSNavTitleLab * lab = [[GSNavTitleLab alloc] init];
    lab.text = @"02";
    self.navigationItem.titleView = lab;
    self.view.backgroundColor = GSColor(230, 230, 230);
}

#pragma mark - 2. scrollTop
- (void)setupTopView
{
    //1.
    UIScrollView * topScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, GSScreenW, BtnH)];
    topScroll.showsHorizontalScrollIndicator = NO;
    topScroll.bounces = NO;
    [self.view addSubview:topScroll];
    self.topScroll = topScroll;
    
    CGFloat btnW = GSScreenW/4.0;
    NSArray * arr = @[@"N号",@"bule",@"记录",@"是你",@"你猜",@"思考",@"示例",@"公司",@"就是",@"版本",@"更改",@"啊啊",@"尺寸",@"订单",@"天天"];
    self.previousBtnTag = 100;
    //2.
    for (int i = 0; i < 15; i++) {
//        NSString * str = [NSString stringWithFormat:@"第%d",i];
        NSString * str = arr[i];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, BtnH)];
        btn.tag = 100 + i;
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topScroll addSubview:btn];
        if (i == 0 ) {
            btn.selected = YES;
            self.proviousBtn = btn;
        }
        
    }
    topScroll.contentSize = CGSizeMake(15*btnW, 0);
    
    //3.条
    UIImageView * barImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, BtnH - LineH, btnW, LineH)];
    barImg.backgroundColor = [UIColor purpleColor];
    [topScroll addSubview:barImg];
    self.barImg = barImg;
}

- (void)topBtnClick:(UIButton *)btn
{
    //1.更改 btn 的状态
    self.proviousBtn.selected = NO;
    btn.selected = YES;
    self.proviousBtn = btn;
 
    
    //2.根据tag 的差值 给定动画时间
    NSInteger nowBtnTag = btn.tag;
    int timerDuration = abs((int)self.previousBtnTag - (int)nowBtnTag);
    self.previousBtnTag = btn.tag;
    
    self.nowBtnTag = btn.tag;
    if (timerDuration > 2) {
        timerDuration = 2;
    }
    
    [UIView animateWithDuration:timerDuration*0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        self.barImg.frame =  CGRectMake(btn.gs_x, BtnH - LineH, GSScreenW/4.0, LineH);
        
        
    } completion:^(BOOL finished) {
        [self.bottomScroll setContentOffset:CGPointMake(GSScreenW*(nowBtnTag - 100), 0)];
        
        for (int i = 0; i < self.bottomScroll.subviews.count; i++) {
            if (i == (nowBtnTag - 100)) {
                GSCustomTableView * table = self.bottomScroll.subviews[i];
                [table customReloadData];
            }
        }
    }];
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat btnW = GSScreenW/4.0;
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    for (int i = 0 ; i < self.topScroll.subviews.count; i++) {
        if (i == pageInt) {
            UIButton * btn = self.topScroll.subviews[i];
            [self topBtnClick:btn];

            if (pageInt >= 1 && pageInt <= 12) {
                [self.topScroll setContentOffset:CGPointMake(btnW*(pageInt - 1), 0) animated:YES];
            }
           
            if (pageInt == 0) {
                [self.topScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            }
           
            if (pageInt == 13 || pageInt == 14) {
                [self.topScroll setContentOffset:CGPointMake(btnW*11, 0) animated:YES];
            }
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
#pragma mark - 3.
- (void)setupMiddleView
{
    UIScrollView * bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BtnH, GSScreenW, GSScreenH  - BtnH - GSTabbarSafeBottomMargin - GSNavMaxY - GSTabBarH)];
    bottomScroll.bounces = NO;
    bottomScroll.pagingEnabled = YES;
    bottomScroll.delegate = self;
    bottomScroll.contentSize = CGSizeMake(GSScreenW*15, 0);
    [self.view addSubview:bottomScroll];
    self.bottomScroll = bottomScroll;
    
    bottomScroll.backgroundColor = [UIColor grayColor];
    for (int i = 0; i < 15; i++) {
        //3.创建 tableview
        GSCustomTableView * tableView = [[GSCustomTableView alloc] initWithFrame:CGRectMake(GSScreenW*i, 0, GSScreenW, bottomScroll.gs_height)];
        if (i % 2 == 0 ) {
            tableView.backgroundColor = [UIColor orangeColor];
        }else{
            tableView.backgroundColor = [UIColor whiteColor];
        }
        tableView.type = i;
        [bottomScroll addSubview:tableView];

    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
