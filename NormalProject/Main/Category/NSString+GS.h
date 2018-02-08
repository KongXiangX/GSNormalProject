//
//  NSString+GS.h
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_STATIC_INLINE BOOL NSStringIsEmpty(NSString *string)
{
    if (string == nil || string.length == 0) {
        return YES;
    }
    return NO;
}
@interface NSString (GS)
#pragma mark - 编码解码

/// URL encode (UTF8)
- (NSString *)lf_stringByURLEncode;
/// URL decode (UTF8)
- (NSString *)lf_stringByURLDecode;

/// URL encode
- (NSString *)lf_stringByURLEncode:(NSStringEncoding)encoding;
/// URL decode
- (NSString *)lf_stringByURLDecode:(NSStringEncoding)encoding;

/// 将html字符转义。 例如将 '<' 转为 '&lt;'
- (NSString *)lf_stringByEscapingHTML;

#pragma mark - 绘制
/// 计算字符串的绘制大小
- (CGSize)lf_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/// 计算字符串的绘制宽度 (单行)
- (CGFloat)lf_widthForFont:(UIFont *)font;

/// 计算字符串的绘制高度 (定宽)
- (CGFloat)lf_heightForFont:(UIFont *)font width:(CGFloat)width;

/// 计算字符串的绘制高度
/// @param width 最大宽度
/// @param maxLine 最大行数 (比如传入3，则字超过3行时，会截取3行的高度返回)
- (CGFloat)lf_heightForFont:(UIFont *)font width:(CGFloat)width line:(NSInteger)maxLine;




#pragma mark - Utilities

/// 返回一个随机 UUID 例如 "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
+ (NSString *)lf_stringWithUUID;

/// 切去头尾的空白字符 (空格/换行等)
- (NSString *)lf_stringByTrim;



/// 是否非空 (例如 nil, @"", @"  ", @"\n" 返回 NO)
- (BOOL)lf_isNotBlank;

/// 是否包含 charset 中的字符
- (BOOL)lf_containsCharacterSet:(NSCharacterSet *)set;



/// 以 UTF8 编码，转为NSData
- (NSData *)lf_dataValue;



/// 从 Main bundle 的文件创建字符串，(类似 [UIImage imageNamed:])
- (NSString *)lf_stringNamed:(NSString *)name;

// liyuan+ 数字字符串用逗号分隔
- (NSString *)lf_segmentString;


@end
