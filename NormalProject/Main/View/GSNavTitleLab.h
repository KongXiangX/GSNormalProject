//
//  GSNavTitleLab.h
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNavTitleLab : UILabel

/**
 自定义导航栏 标题

 @param title 标题文字
 @return lab类型
 */
+ (instancetype)defaultNavTitleLabWithTitle:(NSString *)title;
@end
