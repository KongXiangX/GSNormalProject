
//
//  GSBaseVC.m
//  GSHX
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSBaseVC.h"

@interface GSBaseVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
//1.是否 是第一次 加载数据
@property (nonatomic, assign) BOOL isFirstLoad;
//2.空白 页面对应 提示的图片
@property (nonatomic, copy  )  NSString * emptyDataAlertImgStr;
@end

@implementation GSBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstLoad = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 1. 空白数据 处理
//1.0 tableView 无数据状态的处理
- (void)addEmptyDataSetWithTableView:(UITableView *)table isFirstLoad:(BOOL)isFirstLoad
{
    if (isFirstLoad) {
        table.emptyDataSetSource = self;
        table.emptyDataSetDelegate = self;
        table.tableFooterView = [UIView new];
    }
    
}

//1.2  已经开始加载数据 isFirstLoad == NO；
- (void)hasStartedLoadData
{
    self.isFirstLoad = NO;
}

//1.3 tableView 无数据状态的处理 扩展方法
- (void)addEmptyDataSetWithTableView:(UITableView *)table  withImgNamed:(NSString *)emptyDataAlertImgStr isFirstLoad:(BOOL)isFirstLoad
{
    [self addEmptyDataSetWithTableView:table isFirstLoad:YES];
    self.emptyDataAlertImgStr = emptyDataAlertImgStr;
}

#pragma mark -- 1.1 DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!self.isFirstLoad) {
        NSString * imgStr;
        if (self.emptyDataAlertImgStr.length == 0) {
            imgStr = @"NoData";
        }else{
            imgStr = self.emptyDataAlertImgStr;
        }
        
        return [UIImage imageNamed:imgStr];
    }else{
        return nil;
    }
    
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - 2.断网提示
//断网提示
- (void)NoNetAlert
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:GS_NO_NETWORK];
    [SVProgressHUD dismissWithDelay:2.0f];
}

- (void)NONetAlertWithTableView:(UITableView *)tableview
{
    
    [self endRefreshWithTableView:tableview];
    [tableview reloadEmptyDataSet];
    [self NoNetAlert];
}

#pragma mark - 3.结束刷新
-(void)endRefreshWithTableView:(UITableView *)tableview{
    [SVProgressHUD dismiss];
    [tableview.mj_header endRefreshing];
    [tableview.mj_footer endRefreshing];
}
@end
