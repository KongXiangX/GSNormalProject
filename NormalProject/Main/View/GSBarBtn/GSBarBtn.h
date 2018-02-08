//
//  GSBarBtn.h
//  GSHX
//
//  Created by apple on 2018/1/25.
//  Copyright © 2018年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSBarBtn : UIButton

/**
 返回按钮（有Nav的）
 
 @param action 方法
 @return UIButton类型
 */
+ (instancetype)defaultBarBackBtnWithAction:(SEL)action;


/**
 返回按钮（没有 Nav的）

 @param vc 当期所在的VC (填写self)
 @param action 方法
 @return UIButton类型
 */
+ (instancetype)defaultBarBackBtnWithViewController:(UIViewController *)vc action:(SEL)action;


/**
 自定义barItem -- title(2个文字)  （按钮）

 @param title 文字
 @param action 方法
 @return UIButton类型
 */
+ (instancetype)defaultBarBtnWithTitle:(NSString *)title action:(SEL)action;



/**
 自定义barItem -- img(图片30*30pt)  （按钮）

 @param imgStr 图片名称
 @param action 方法
 @return UIButton类型
 */
+ (instancetype)defaultBarBtnWithImageNamed:(NSString *)imgStr action:(SEL)action;
@end
