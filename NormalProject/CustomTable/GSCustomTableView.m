//
//  GSCustomTableView.m
//  NormalProject
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSCustomTableView.h"

@interface GSCustomTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * table;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray * arr;
@property (nonatomic, assign) int  count;
@end

@implementation GSCustomTableView

- (instancetype)init
{
    if (self = [super init]) {
         [self setupBasic];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBasic];
    }
    return self;
}

- (void)setupBasic
{
    
    self.count = 5;
    //3.创建 tableview
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.table = tableView;
    
    

    [self loadRefreshView];
}
- (void) loadRefreshView
{
    // 下拉刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:_refreshControl];
    [self.table sendSubviewToBack:_refreshControl];
}

// 设置刷新状态
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    decelerate = YES;
    if (scrollView.contentOffset.y < 50) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新"];
        });
        [_refreshControl beginRefreshing];
        [self loadData];
    }
}

// 设置刷新状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 50) {
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    }
    else if (!scrollView.decelerating) {
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"松开刷新"];
    }
}

// 结束刷新
- (void) endRefreshControl
{
    [_refreshControl endRefreshing];
    self.count = 10;
    [self.table reloadData];
    
}

// 刷新的回调方法
- (void) loadData
{
//    [self endRefreshControl];
     [self performSelector:@selector(endRefreshControl) withObject:nil afterDelay:2];
}

//设置如果collection的内容没有占满整个collectionView，
//这个就不能下拉滑动，没法实现下拉；但是设置下面这个就可以实现下拉了
//self.rootView.collectionView.alwaysBounceVertical = YES;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"ceshi %d--%ld",self.type,indexPath.row];
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.table.frame = CGRectMake(0, 0, GSScreenW, self.gs_height);
}

- (void)customReloadData
{
    [self.table reloadData];
}



- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}

@end
