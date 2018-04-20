//
//  GSFAQFrame.m
//  NormalProject
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSFAQFrame.h"

@implementation GSFAQFrame
- (void)setFAQModle:(GSFAQModel *)FAQModle
{
    _FAQModle = FAQModle;
    
    
    CGFloat width = GSScreenW - GSBigViewMargin;
    CGFloat margin = 5.0;
    //1.标题
    CGFloat titleH = [_FAQModle.title lf_heightForFont:GSNormalFont width:width];
    _titleFrame = CGRectMake(GSSmallViewMargin, 0, width, titleH);
    
    //2.内容
    CGFloat contentH = [_FAQModle.content lf_heightForFont:GSDefaultSubFont width:width];
    _contentFrame = CGRectMake(GSSmallViewMargin, titleH + margin, width, contentH);
    
    //3.总高
    _totalHeight = titleH + contentH + margin*2;
    
    
}

@end
