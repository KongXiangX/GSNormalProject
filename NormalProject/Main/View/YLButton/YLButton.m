
//
//  YLButton.m
//  YLButton
//
//  Created by HelloYeah on 2016/11/24.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLButton.h"

@implementation YLButton

//默认初始化上图下文 按钮
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img  title:(NSString *)title
{
    YLButton * btn = [[YLButton alloc] initWithFrame:frame];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    
    CGFloat btnH = frame.size.height;
    CGFloat btnW = frame.size.width;
    
    CGFloat imgH;
    if (btnH <= 50) {
        imgH = btnH*0.4;

    }else{
        imgH = btnH*0.5;
    }
    
    //1.
    CGFloat margin = btnH*0.1; //距离顶部的间距 、文字与图片的间距
    CGFloat bottomMargin = 5;  //title 距离底部、距离 左右边 的间距
    
    //2.
    CGFloat imgW = img.size.width * imgH / img.size.height;
    CGFloat imgX = (btnW - imgW)*0.5;

    //3.
    CGFloat titleH =  btnH - margin*2 -imgH - bottomMargin;
    
    //4.
    btn.imageRect = CGRectMake(imgX, margin,imgW , imgH);
    btn.titleRect = CGRectMake(bottomMargin, btnH - titleH - bottomMargin, btnW - bottomMargin*2,titleH);

    return btn;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}



@end
