//
//  UITextField+JGL.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (JGL)
/**
 添加文件输入框左边的View,添加图片
 */
-(void)addLeftViewWithImage:(NSString *)image;


/**
 * 判断是否为手机号码
 */
-(BOOL)isTelphoneNum;
@end
