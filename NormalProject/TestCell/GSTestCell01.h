//
//  GSTestCell01.h
//  NormalProject
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSTestCell01 : UITableViewCell
@property (nonatomic, strong) NSIndexPath *path;

+ (instancetype)testCell01WithTableView:(UITableView *)tableView;


@end
