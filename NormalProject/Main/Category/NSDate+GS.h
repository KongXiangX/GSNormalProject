//
//  NSDate+GS.h
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDateItem : NSObject
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;
@end



@interface NSDate (GS)
- (GSDateItem *)gs_timeIntervalSinceDate:(NSDate *)anotherDate;

- (BOOL)gs_isToday;
- (BOOL)gs_isYesterday;
- (BOOL)gs_isTomorrow;
- (BOOL)gs_isThisYear;
//获取今天周几
- (NSInteger)getNowWeekday;
@end
