//
//  AppDelegate.h
//  02-xmpp框架
//
//  Created by jiaguanglei on 15/9/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

/**
 *  移动平台: iOS7.0 - iOS8 (iPhone +iPad)
 *
 *  服务器: Openfire 3.10
 *  数据库: MySQL 5.6
 *  开发工具: Xcode 6.4
 *  版本控制器: git
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  注销
 */
- (void)signOut;

@end

