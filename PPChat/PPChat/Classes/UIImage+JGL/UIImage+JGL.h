//
//  UIImage+JGL.h
//  SET_LIB
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 BJ. All rights reserved.
//

/**
 *  适配iOS7 和 iOS6,拦截setImage方法
 */
#import <UIKit/UIKit.h>

@interface UIImage (JGL)

/**
 *  加载图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;


/*** *** *** *** *** ***      切图      *** *** *** *** ***  *** *** *** *** ***/
#pragma mark - 切图

/**
 *  屏幕截图
 *
 *  @param view 需要截图的view
 *
 *  @return 新的图片
 */
+ (UIImage *)captureWithView:(UIView *)view;

/**
 *  - 切圆形图
 *
 *  @param borderW     边框宽度
 *  @param borderColor 边框颜色
 *  @param imageName   原始图片的名称
 *
 *  @return 新的图片
 */
+ (UIImage *)clipARCImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName;

/**
 *  切方形图
 **/
+ (UIImage *)clipRectImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName;

/**
 *  打水印
 *
 *  @param bg   背景图片
 *  @param logo 水印
 *
 *  @return 新的图片
 */
+ (UIImage *)blockImageWithBg:(NSString *)bg logo:(NSString *)logo;


@end
