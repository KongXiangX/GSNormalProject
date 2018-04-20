//
//  ViewController.m
//  NormalProject
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initViews];
    [self setupBasic];
}
- (void)setupBasic
{
    
    
    
    
    //3.创建 tableview
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, GSScreenW, GSScreenH - GSNavMaxY - GSTabbarSafeBottomMargin  - 50) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GSScreenW, 50)];
    lab.text = @"sdfsdfsdf";
    lab.textColor = [UIColor blueColor];
    [self.view addSubview:lab];
    //    tableView.tableHeaderView = lab;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"ceshi --%ld",indexPath.row];
    return cell;
}
- (void)initViews {
//    UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(0, 100, GSScreenW, 50)];
//    bg.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:bg];
//    
//    _label1 = [UILabel new];
//    _label1.backgroundColor = [UIColor yellowColor];
//    _label1.text = @"label,";
//    
//    _label2 = [UILabel new];
//    _label2.backgroundColor = [UIColor greenColor];
//    _label2.text = @"label,";
//    
//    [self.view addSubview:_label1];
//    [self.view addSubview:_label2];
//
//    // label1: 位于左上角
//    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bg.mas_top).with.offset(5);
//        make.left.equalTo(bg.mas_left).with.offset(2);
//        make.height.equalTo(@40);
//    }];
//    
//    
//    // label2: 位于右上角
//    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_label1.mas_right).with.offset(2);
//        make.top.equalTo(bg.mas_top).with.offset(5);
//        make.right.lessThanOrEqualTo(bg.mas_right).with.offset(-2);
//        make.height.equalTo(@40);
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
