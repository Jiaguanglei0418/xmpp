//
//  AppDelegate.m
//  02-xmpp框架
//
//  Created by jiaguanglei on 15/9/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "AppDelegate.h"
#import "PPNavigationViewController.h"


#import "DDLog.h" // 日志
#import "DDTTYLogger.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 沙盒路径
    LogPurple(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    
    
    // 打开日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 设置状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 设置导航栏的主题
    [PPNavigationViewController setupTheme];
    
    // 从沙盒中加载用户信息
    [[PPUserInfo sharedPPUserInfo] loadUserInfoFromSandbox];
    
    // 判断用户的登录状态 - yes主界面 -no登录
    if([PP_NSUSRDEFAULT boolForKey:KEY_LoginStatus]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        
        // 自动登录服务器(已近登陆过,再次进入程序,之前与服务器的链接 已断开)
        [[XMPPTool sharedXMPPTool] xmppUserLogin:nil];
        
    }else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
