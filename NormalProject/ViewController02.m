//
//  ViewController02.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "ViewController02.h"

@interface ViewController02 ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
    GSNavTitleLab * lab = [[GSNavTitleLab alloc] init];
    lab.text = @"02";
    self.navigationItem.titleView = lab;
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    //1.创建 tableview
    UITableView * tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, GSScreenW, GSScreenH - 64);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor orangeColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
//    self.tableView = tableView;
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
    

    cell.textLabel.text = @"jlksjdf";
    return cell;
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
