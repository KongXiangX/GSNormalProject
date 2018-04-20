
//
//  GSFAQView.m
//  NormalProject
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSFAQView.h"

@interface GSFAQView ()
@property (nonatomic, weak ) UILabel * topLab;      //1.标题
@property (nonatomic, weak ) UILabel * bottomLab;   //2.内容

@end

@implementation GSFAQView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        //1.问题
        UILabel * topLab = [[UILabel alloc] init];
        topLab.numberOfLines = 0;
        topLab.font = GSNormalFont;
        topLab.textColor = [UIColor orangeColor];
        [self addSubview:topLab];
        self.topLab = topLab;
        
        //2.解释
        UILabel * bottomLab = [[UILabel alloc] init];
        bottomLab.numberOfLines = 0;
        bottomLab.font = GSDefaultSubFont;
        bottomLab.textColor = [UIColor blackColor];
        [self addSubview:bottomLab];
        self.bottomLab = bottomLab;
      
     
        
    }
    return self;
}

- (void)setFaqFrame:(GSFAQFrame *)faqFrame
{
    _faqFrame = faqFrame;
    
    GSFAQModel * model = _faqFrame.FAQModle;
    //1.标题
    self.topLab.text = model.title;
    self.topLab.frame = _faqFrame.titleFrame;
    
    //2.内容
    self.bottomLab.text = model.content;
    self.bottomLab.frame = _faqFrame.contentFrame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
  
}

@end
