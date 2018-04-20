

//
//  GSTestCell03.m
//  NormalProject
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018年 GS. All rights reserved.
//

#import "GSTestCell03.h"

@interface GSTestCell03()

@property (nonatomic, weak ) UILabel * titleLab;
@property (nonatomic, weak ) UIImageView * barImg;
@end

@implementation GSTestCell03

#pragma mark - 快速创建Cell
+ (instancetype)testCell03WithTableView:(UITableView *)tableView
{
    static NSString * GSTestCell03ID = @"GSTestCell03ID";
    GSTestCell03 *cell = [tableView dequeueReusableCellWithIdentifier:GSTestCell03ID];
    if (cell == nil) {
        cell = [[GSTestCell03 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GSTestCell03ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    
        
        //2.标题
        [self setupTitleLab];
  
        //6.分割线
        UIImageView * barImg = [[UIImageView alloc] init];
        barImg.backgroundColor = [UIColor  grayColor];
        [self.contentView addSubview:barImg];
        self.barImg = barImg;
    }
    return self;
}

#pragma mark -2.标题
- (void)setupTitleLab
{
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textColor = [UIColor  blackColor];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat btnW = GSScreenW*0.2;
    CGFloat leftImgW = 50;
    CGFloat titleLabW = GSScreenW - GSSmallViewMargin*2 - GSBigViewMargin - btnW - leftImgW;
    
  
    //2.标题
    self.titleLab.frame = CGRectMake(GSSmallViewMargin*2 + leftImgW, GSSmallViewMargin, titleLabW, leftImgW*0.5);
    
 
    self.barImg.frame = CGRectMake(GSSmallViewMargin, self.gs_height - LineH, GSScreenW - GSSmallViewMargin*2, LineH);
    
 
    self.titleLab.text = @"t甜甜的爱的风格耐股份你说得对那地方阿道夫撒到";

}

- (void)setPath:(NSIndexPath *)path
{
    _path = path;
    if (_path.row % 2 == 0) {
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = GSColor(230, 230, 230);
    }
}
@end
