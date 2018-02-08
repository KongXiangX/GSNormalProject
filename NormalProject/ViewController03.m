//
//  ViewController03.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "ViewController03.h"

@interface ViewController03 ()

@end

@implementation ViewController03

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GSNavTitleLab * lab = [[GSNavTitleLab alloc] init];
    lab.text = @"03";
    self.navigationItem.titleView = lab;
    
    
    self.view.backgroundColor = [UIColor grayColor];

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
