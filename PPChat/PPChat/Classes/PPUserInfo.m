//
//  PPUserInfo.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPUserInfo.h"

@implementation PPUserInfo

singleton_implementation(PPUserInfo)

// save
- (void)saveUserInfoToSandbox
{
    // 用户名
    [PP_NSUSRDEFAULT setObject:self.username forKey:KEY_USER];
    
    // 密码
    [PP_NSUSRDEFAULT setObject:self.password forKey:KEY_PWD];
    
    // 登录状态
    [PP_NSUSRDEFAULT setBool:self.loginStatus forKey:KEY_LoginStatus];
    
    // 同步
    [PP_NSUSRDEFAULT synchronize];
}

// load
- (void)loadUserInfoFromSandbox
{
    self.username = [PP_NSUSRDEFAULT objectForKey:KEY_USER];
    self.password = [PP_NSUSRDEFAULT objectForKey:KEY_PWD];
    self.loginStatus = [PP_NSUSRDEFAULT boolForKey:KEY_LoginStatus];
}
@end
