//
//  YLButton.h
//  YLButton
//
//  Created by HelloYeah on 2016/11/24.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLButton : UIButton

/**
 默认初始化上图下文 按钮

 @param frame 按钮 frame
 @param img 图片
 @param title 文字
 @return 上图下文按钮
 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img  title:(NSString *)title;

@property (nonatomic,assign) CGRect titleRect;
@property (nonatomic,assign) CGRect imageRect;
@end
