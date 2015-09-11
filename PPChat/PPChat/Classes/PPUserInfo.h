//
//  PPUserInfo.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface PPUserInfo : NSObject

singleton_interface(PPUserInfo)

@property (nonatomic, copy) NSString *username; //用户名

@property (nonatomic, copy) NSString *password; //密码

@property (nonatomic, assign) BOOL loginStatus; // 登录状态 yes-登录 no-注销


// 将用户信息保存到沙盒
- (void)saveUserInfoToSandbox;


// 加载用户信息
- (void)loadUserInfoFromSandbox;

@end
