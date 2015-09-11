//
//  UIImage+JGL.m
//  SET_LIB
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 BJ. All rights reserved.
//

#import "UIImage+JGL.h"


@implementation UIImage (JGL)
/**
 *  适配iOS6 和 iOS7
 *
 */
+ (UIImage *)imageWithName:(NSString *)name{
//    if (iOS7) {
//        NSString *newName = [name stringByAppendingString:@"_os7"];
//        UIImage *image = [UIImage imageNamed:newName];
//        if (image == nil) { // 没有_os7后缀的图片
//            image = [UIImage imageNamed:name];
//        }
//        return image;
//    }
    // 非iOS7
    return [UIImage imageNamed:name];
}

/**
 *  瓦片平铺图片
 *
 */
+ (UIImage *)resizedImageWithName:(NSString *)name{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


/*** *** *** *** *** ***      切图      *** *** *** *** ***  *** *** *** *** ***/
#pragma mark - 切图
/**
 *  截屏
 **/
+ (UIImage *)captureWithView:(UIView *)view{
    // 1. 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    // 2. 将控制器View的layer 渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    // 3. 取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


/**
 *  切圆形图
 **/
+ (UIImage *)clipARCImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName
{
    
    // 0.加载原图
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    // 1. 开启一个上下文
    //    CGFloat borderW = borderW;
    CGFloat imageW = image.size.width + borderW * 2;
    CGFloat imageH = image.size.height + borderW * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize , NO, 0.0);
    
    // 2. 取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 3.1 画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    // 渲染
    CGContextFillPath(context);
    
    // 3.2.画小圆 (用来裁剪)
    //    [[UIColor greenColor] set];
    CGFloat smallRadius = bigRadius - borderW;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 1);
    // 裁剪
    // 后面画的图像,才会受clip影响, 前面无影响
    CGContextClip(context);
    
    // 3.3 画图
    [image drawInRect:CGRectMake(borderW, borderW, imageW, imageH)];
    
    // 4. 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  切方形图
 **/
+ (UIImage *)clipRectImageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName
{
    
    // 0.加载原图
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    // 1. 开启一个上下文
    //    CGFloat borderW = borderW;
    CGFloat imageW = image.size.width + borderW * 2;
    CGFloat imageH = image.size.height + borderW * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize , NO, 0.0);
    
    // 2. 取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 3.1 画边框(大方框)
    [borderColor set];
    CGFloat imageX = borderW;
    CGFloat imageY = borderW;
    CGContextAddRect(context, CGRectMake(imageX, imageY, imageW, imageH));
    
    // 渲染
    CGContextFillPath(context);
    
    // 3.2.画小圆 (用来裁剪)
    //    [[UIColor greenColor] set];
    CGFloat smallX = imageX + borderW;
    CGFloat smallY = imageY + borderW;
    CGFloat smallW = imageW - borderW * 2;
    CGFloat smallH = imageH - borderW * 2;
    CGContextAddRect(context, CGRectMake(smallX, smallY, smallW, smallH));
    
    // 裁剪
    // 后面画的图像,才会受clip影响, 前面无影响
    CGContextClip(context);
    
    // 3.3 画图
    [image drawInRect:CGRectMake(borderW, borderW, imageW, imageH)];
    
    // 4. 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 *  打水印
 **/
+ (UIImage *)blockImageWithBg:(NSString *)bg logo:(NSString *)logo{
    UIImage *bgImage = [UIImage imageNamed:bg];
    
    /**
     *  上下文  -   基于位图(bitmap)
     *
     *  @所有的东西 都要绘制到一张新的图片上去
     */
    // 1.创建一个基于位图的上下文 - 开启一个上下文
    UIGraphicsBeginImageContextWithOptions(bgImage.size, YES, 0.0);
    
    // 2. 将背景图片 画到新的图片上
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3. 将水印画到新的图片上
    UIImage *waterImage = [UIImage imageNamed:logo];
    
    CGFloat scale = 0.4;
    CGFloat margin = 2;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 4. 从上下文中取出 制作完成的UIImageView
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
