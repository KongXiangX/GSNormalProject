//
//  GSHelperUtil.h
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GSHelperUtil : NSObject
+ (NSString *)htmlShuangyinhao:(NSString *)values;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr;

#pragma 正则匹配邮箱号
+ (BOOL)checkMailInput:(NSString *)mail;
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 正则匹配昵称
+ (BOOL) checkNickname:(NSString *) nickname;
#pragma 正则匹配以C开头的18位字符
+ (BOOL) checkCtooNumberTo18:(NSString *) nickNumber;
#pragma 正则匹配以C开头字符
+ (BOOL) checkCtooNumber:(NSString *) nickNumber;
#pragma 正则匹配银行卡号是否正确
+ (BOOL) checkBankNumber:(NSString *) bankNumber;
#pragma 正则匹配17位车架号
+ (BOOL) checkCheJiaNumber:(NSString *) CheJiaNumber;
#pragma 正则只能输入数字和字母
+ (BOOL) checkTeshuZifuNumber:(NSString *) CheJiaNumber;
#pragma 车牌号验证
+ (BOOL) checkCarNumber:(NSString *) CarNumber;

//自己

/**
 openURL :10 以后适配
 
 @param urlStr 具体电话/网址 字符串
 */
+ (void)adaptationOpenUrlWithUrlStr:(NSString *)urlStr;

+ (void)adaptationOpenUrlWithUrlStr:(NSString *)urlStr options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion;


/**
 断网 提示
 */
+ (void)NoNetAlert;




/**
 是否 打开 打开定位权限
 @return YES/NO
 */
+ (BOOL)isOpenCoreLocation;

@end
