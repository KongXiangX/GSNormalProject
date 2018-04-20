//
//  GSCustomTableView.h
//  NormalProject
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSCustomTableView : UIView
@property (nonatomic, copy  )  NSString * postUrlStr;
@property (nonatomic, assign)  int   type;

- (void)customReloadData;
@end
