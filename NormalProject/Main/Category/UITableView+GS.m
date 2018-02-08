//
//  UITableView+GS.m
//  NormalProject
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 GS. All rights reserved.
//

#import "UITableView+GS.h"

@implementation UITableView (GS)
- (void)adaptationIPhoneXTable
{
    if (iOS11) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        //        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        self.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        //        self.scrollIndicatorInsets = self.contentInset;
    }
    
//    if (iPhoneX) {
//        self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//    }
}
@end
