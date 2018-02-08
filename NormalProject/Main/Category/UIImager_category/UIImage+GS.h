//
//  UIImage+GS.h
//  NormalProject
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GS)
#pragma mark - 图像拉伸

/*!
 按照图片的中心点拉伸图片
 @result 拉伸后的图片
 */
- (UIImage *)lf_stretchableImageWithCenter;



#pragma mark - 图像创建

/**
 从gif创建动态图像。创建完成后，可以通过.images属性来访问所有帧。
 如果data不是gif，这个方法就和[UIImage imageWithData:data scale:scale]一样了。
 
 @discussion     用这个方法创建的动画有比较好的显示性能，但是会耗费较多内存 (width * height * frames)
 所以这个方法只适合用于显示小gif，例如小表情。
 如果需要显示较大的gif，最好换成 LFGIFImage
 */
+ (UIImage *)lf_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

/**
 判断一个data是否是动画gif。
 只有当是gif并且包含多帧图像时，才返回YES。
 */
+ (BOOL)lf_isAnimatedGIFData:(NSData *)data;

/**
 由PDF创建Image。 (如果PDF是多页，则只读取第一页)
 */
+ (UIImage *)lf_imageWithPDF:(id)dataOrPath;

/**
 由PDF创建Image。 (如果PDF是多页，则只读取第一页)
 */
+ (UIImage *)lf_imageWithPDF:(id)dataOrPath size:(CGSize)size;



/**
 创建一个 1x1 大小的纯色图片
 */
+ (UIImage *)lf_imageWithColor:(UIColor *)color;

/**
 创建一张纯色图片
 */
+ (UIImage *)lf_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 用QuartZ画出一个图片
 */
+ (UIImage *)lf_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;


#pragma mark - 图片信息
/**
 获取图片上某一点的颜色
 
 @param point  图片内的一个点。范围是 [0, image.width-1],[0, image.height-1]
 超出图片范围则返回nil
 */
- (UIColor *)lf_colorAtPoint:(CGPoint)point;

/**
 该图片是否有alpha通道
 */
- (BOOL)lf_hasAlphaChannel;


#pragma mark - 修改图片
/// 调整图片大小 (内容可能会被拉伸)
- (UIImage *)lf_imageByResizeToSize:(CGSize)size;

/// 调整图片大小 (内容会根据contentMode来调整)
- (UIImage *)lf_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/// 从内部裁剪出一块儿。
- (UIImage *)lf_imageByCropToRect:(CGRect)rect;


/**
 用 edge inset 来调整图片
 @param insets  Inset (positive) for each of the edges, values can be negative to 'outset'.
 @param color   Extend edge's fill color, nil means clear color.
 */
- (UIImage *)lf_imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color;

/**
 为图片裁剪出圆角
 @param radius  圆角的半径(如果超出图片宽高，内部会调整以适应图片)
 */
- (UIImage *)lf_imageByRoundCornerRadius:(CGFloat)radius;

/**
 为图片裁剪出圆角
 @param radius  圆角的半径(如果超出图片宽高，内部会调整以适应图片)
 @param corners  裁剪哪几个角
 @param borderWidth  可以加一个border
 */
- (UIImage *)lf_imageByRoundCornerRadius:(CGFloat)radius
                                 corners:(UIRectCorner)corners
                             borderWidth:(CGFloat)borderWidth;

/**
 旋转图片 (中心旋转)
 @param radians   旋转弧度 (逆时针).⟲
 @param fitSize   YES: 旋转后，图片大小会扩大以包含全部内容
 NO: 旋转后，图片大小不变，某些内容会被裁剪
 */
- (UIImage *)lf_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;


/// 向左旋转90° ⤺ (图片宽高会对调)
- (UIImage *)lf_imageByRotateLeft90;

/// 向右旋转90° ⤺ (图片宽高会对调)
- (UIImage *)lf_imageByRotateRight90;

/// 旋转180°
- (UIImage *)lf_imageByRotate180;

/// 上下翻转 ⥯
- (UIImage *)lf_imageByFlipVertical;

/// 左右翻转 ⇋
- (UIImage *)lf_imageByFlipHorizontal;




@end





#pragma mark - Helper functions

/**
 Create a decoded image (may useful for display), see `-imageByDecoded`.
 */
CGImageRef CGImageCreateDecoded(CGImageRef imageRef);
