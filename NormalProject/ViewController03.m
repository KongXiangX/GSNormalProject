//
//  ViewController03.m
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "ViewController03.h"
#import "GSFAQFrame.h"
#import "GSFAQView.h"

@interface ViewController03 ()
@property (nonatomic, weak  ) UIScrollView * scrollBG;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end

@implementation ViewController03

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GSNavTitleLab * lab = [[GSNavTitleLab alloc] init];
    lab.text = @"03";
    self.navigationItem.titleView = lab;
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    //2.scrollBG
    [self setupScrollBG];
    
    
    //3.假数据
    self.dataArr = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i < 20; i++) {
        NSString * titleStr = [NSString stringWithFormat:@"%d.我是测试标题：伯尔尼嘶哑普罗你修斯.德尔普的施旺.欧的必拉米小夫斯基",i];
        NSDictionary * dic = @{@"title" : titleStr,
                               @"content" : @"三纲五常：三纲者，君为臣纲，父为子纲，夫为妇纲；五常者,仁义礼智信； 三从四德：三从：未嫁从父、出嫁从夫、夫死从子；四德：妇德、妇言、妇容、妇功。狂魔为小丹佛等你哦艾弗森大佛爱的烦恼的烦恼奥豆腐脑发动覅顶峰哦哦and佛啊asdfadsfkwoe54654654你"
                               };
        [self.dataArr addObject:dic];
    }
    
    //4.赋值
    CGFloat aa = 0;
    for (int i = 0; i < self.dataArr.count; i++) {
        
        GSFAQModel * model = [GSFAQModel mj_objectWithKeyValues:self.dataArr[i]];
        //模型  转换成 frame模型
        GSFAQFrame * faqFrame = [[GSFAQFrame alloc] init];
        faqFrame.FAQModle = model;
        
        
        GSFAQView * faqView = [[GSFAQView alloc] initWithFrame:CGRectMake(0, aa, GSScreenW, faqFrame.totalHeight)];
        faqView.faqFrame = faqFrame;
        [self.scrollBG addSubview:faqView];
        aa = aa + faqFrame.totalHeight;
    }
    
    
   
  
    
    self.scrollBG.contentSize = CGSizeMake(0,aa);

}

#pragma mark - 2.scrollBG
- (void)setupScrollBG
{
    UIScrollView * scrollBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, GSScreenW, GSScreenH -  GSTabBarH)];
    scrollBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollBG];
    self.scrollBG = scrollBG;
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
