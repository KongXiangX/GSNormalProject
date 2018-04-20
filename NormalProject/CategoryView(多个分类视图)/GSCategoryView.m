

//
//  GSCategoryView.m
//  NormalProject
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSCategoryView.h"

@interface GSCategoryView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;            //scroll
@property (nonatomic, strong) UIView * barView;                     //移动 横条
@property (nonatomic, weak  ) UIButton * previousClickedTitleBtn;   //处理点击按钮 使用
@property (nonatomic, assign) NSInteger  previousClickedTitleBtnTag;//上一个Btnd的tag

@end

@implementation GSCategoryView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//
//        self.previousClickedTitleBtnTag = 100;
//        //1. 初始化 scrollView
//        [self setupScrollView];
//
//        //2. 移动 横条
//        [self setupVerBar];
//
//    }
//    return self;
//}
//#pragma mark -1. 初始化 scrollView
//- (void)setupScrollView
//{
//    UIScrollView * scrollView = [[UIScrollView alloc] init];
//    scrollView.delegate = self;
//    scrollView.backgroundColor = [UIColor orangeColor];
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.pagingEnabled = NO;
//    //    scrollView.bounces = NO;
//    self.scrollView = scrollView;
//    [self addSubview:scrollView];
//
//}
//#pragma mark -2. 移动 横条
//- (void)setupVerBar
//{
//    UIView * barView = [[UIView alloc] init];
//    barView.backgroundColor = [UIColor purpleColor];
//    self.barView = barView;
//    [self.scrollView addSubview:barView];
//
//}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    CGFloat viewH = self.frame.size.height;
//    //1.scroll
//    self.scrollView.frame = CGRectMake(0, 0, GSScreenW, viewH);
//    for (int i = 0 ; i< 9; i++) {
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag = 100+i;
//        [btn setTitle:[NSString stringWithFormat:@"第%d",i] forState:UIControlStateNormal];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.frame = CGRectMake((QYScreenW * i) /5 , 0, QYScreenW/5 , viewH-2);
//        [self.scrollView addSubview:btn];
//
//        //1.1默认第一个btn 的颜色
//        if (i == 0) {
//            btn.backgroundColor = [UIColor grayColor];
//            self.previousClickedTitleBtn = btn;
//        }else{
//            btn.backgroundColor = [UIColor orangeColor];
//        }
//    }
//
//    self.scrollView.contentSize = CGSizeMake((QYScreenW*9)/5 , 0);
//
//
//    //2.条
//    self.barView.frame =  CGRectMake(0, viewH - 2, QYScreenW/5, 2);
//
//}
//
//- (void)btnClick:(UIButton *)btn
//{
//    //1.更改 btn 的状态
//    self.previousClickedTitleBtn.backgroundColor = [UIColor orangeColor];
//    self.previousClickedTitleBtn.selected = NO;
//    btn.selected = YES;
//    self.previousClickedTitleBtn = btn;
//    btn.backgroundColor = [UIColor grayColor];
//
//    //2.根据tag 的差值 给定动画时间
//    NSInteger nowBtnTag = btn.tag;
//    int timerDuration = abs((int)self.previousClickedTitleBtnTag - (int)nowBtnTag);
//
//    self.previousClickedTitleBtnTag = btn.tag;
//
//    if (timerDuration > 2) {
//        timerDuration = 2;
//    }
//
//    [UIView animateWithDuration:timerDuration*0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//        self.barView.frame =  CGRectMake(btn.frame.origin.x, self.frame.size.height - 2, QYScreenW/5, 2);
//    } completion:^(BOOL finished) {
//
//    }];
//    //3.遵守协议
//    if ([self.delegate respondsToSelector:@selector(tapCategroyViewBtn:)]) {
//        [self.delegate tapCategroyViewBtn:btn];
//    }
//
//
//}
//#pragma mark - UIScrollViewDelegate
////禁止惯性滑动
////- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
////{
//////    if (decelerate)
//////    {
//////        dispatch_async(dispatch_get_main_queue(), ^{
//////            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//////        });
//////    }
////}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if ([self.delegate respondsToSelector:@selector(categotyViewScrollViewDidScroll:)]) {
//        [self.delegate categotyViewScrollViewDidScroll:scrollView];
//    }
//}

@end
