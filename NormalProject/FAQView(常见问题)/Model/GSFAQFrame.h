//
//  GSFAQFrame.h
//  NormalProject
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSFAQModel.h"

@interface GSFAQFrame : NSObject
@property (nonatomic, strong) GSFAQModel * FAQModle;            //model

@property (nonatomic, assign, readonly) CGRect titleFrame;      //标题
@property (nonatomic, assign, readonly) CGRect contentFrame;    //内容
@property (nonatomic, assign, readonly) CGFloat totalHeight;    //标题 + 内容 高
@end
