//
//  UIStoryboard+JGL.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (JGL)


/**
 * 1.显示Storybaord的第一个控制器到窗口
 */
+(void)showInitialVCWithName:(NSString *)name;
+(id)initialVCWithName:(NSString *)name;

@end
