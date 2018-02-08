//
//  ViewController01.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "ViewController01.h"
#import "ViewController.h"
#import "GSTextField.h"


#import "YLButton.h"

@interface ViewController01 ()

@end

@implementation ViewController01

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"01";
    
    GSNavTitleLab * lab = [[GSNavTitleLab alloc] init];
    lab.text = @"01";
    self.navigationItem.titleView = lab;
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    
//    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 200, 50)];
//    tf.contentMode =
//    tf.layer.cornerRadius = 10;
//    tf.layer.masksToBounds = YES;
//    tf.placeholder = @"测试";
////    tf.leftViewMode = UITextFieldViewModeAlways ;
////    tf.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
//    tf.textColor = [UIColor blackColor];
//    tf.backgroundColor = [UIColor whiteColor];
//    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:tf];

//    GSTextField * tf = [[GSTextField alloc] initWithFrame:CGRectMake(20, 200, 200, 50)];
////    tf.backgroundColor = [UIColor lightGrayColor];
////    tf.frame = CGRectMake(20, 200, 200, 50);
//    tf.isClearWhileEditing = YES;
////    tf.isPrice = YES;
////    tf.canCopyPaste = NO;
//    [self.view addSubview:tf];
//
  
    //4.按钮
    YLButton * btn = [[YLButton alloc] initWithFrame:CGRectMake(100, 100, 80, 80) image:[UIImage imageNamed:@"11"] title:@"上图下文"];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 80, 80) ];
    [btn2 setTitle:@"22" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}
- (void)btnClick
{
    NSLog(@"sddsfdsf");
}

- (void)statusBtnClick
{
    ViewController * vc = [[ViewController alloc] init];
    vc.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:vc animated:YES];
    
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
