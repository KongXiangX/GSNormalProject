//
//  GSBaseVC.h
//  GSHX
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSBaseVC : UIViewController



/**
 tableView 无数据状态的处理

 @param table 对应的 UITableView
 @param emptyDataAlertImgStr 提示图片的名字
 @param isFirstLoad 是否是初始化时，未获得具体数据的第一次加载
 */
- (void)addEmptyDataSetWithTableView:(UITableView *)table  withImgNamed:(NSString *)emptyDataAlertImgStr isFirstLoad:(BOOL)isFirstLoad;
/**
 tableView 无数据状态的处理

 @param table 对应的 UITableView
 @param isFirstLoad 是否是初始化时，未获得具体数据的第一次加载
 */
- (void)addEmptyDataSetWithTableView:(UITableView *)table isFirstLoad:(BOOL)isFirstLoad;


/**
 已经开始加载数据 isFirstLoad == NO；
 */
- (void)hasStartedLoadData;

////////////////////////////////////////
/**
 断网提示
 */
- (void)NoNetAlert;

/**
 断网提示 (tableView)
 */
- (void)NONetAlertWithTableView:(UITableView *)tableview;

/**
 结束UITableView刷新

 @param tableview UITableView
 */
-(void)endRefreshWithTableView:(UITableView *)tableview;
@end
