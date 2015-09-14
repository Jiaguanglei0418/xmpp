//
//  AppDelegate.m
//  02-xmpp框架
//
//  Created by jiaguanglei on 15/9/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XMPPFramework.h"
#import "PPNavigationViewController.h"
/**
 *  在AppDelegate中实现登录
 
 1. 初始化xmppStream
 2. 连接到服务器(传一个JID)
 3. 连接服务器成功, 发送密码授权
 4. 授权成功以后, 发送在线消息
 */


@interface AppDelegate ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

// 1. 初始化xmppStream
- (void)setupXMPPSteam;

// 2. 连接到服务器
- (void)connectToHost;

// 3.连接服务器成功, 发送密码授权
- (void)sendPasswordTohost;

// 4.授权成功以后, 发送在线消息
- (void)sendOnlineToHost;

@end


@implementation AppDelegate

#pragma mark - 私有方法

#pragma mark - 1.初始化xmppStream
- (void)setupXMPPSteam
{
    PPLog(@"初始化xmppStream--");
    
    // 创建对象
    _xmppStream = [[XMPPStream alloc] init];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}


#pragma mark - 2. 连接到服务器
- (void)connectToHost
{
    if (!_xmppStream) {
        [self setupXMPPSteam];
    }
    
    // 设置JID
    // resource: 标识用户登录客户端, iPhone,android
    
    NSString *user = nil;

    if (self.isRegisterOperation) { // ---  注册
        user = [PPUserInfo sharedPPUserInfo].registerUsername;
    }else{ // 从内存中获取用户名  ---  登录
        user = [PPUserInfo sharedPPUserInfo].username;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:PP_DOMAIN resource:@"iPhone"];
    _xmppStream.myJID = myJID;

    // 设置服务器的域名
    _xmppStream.hostName = PP_DOMAIN; // IP也可以
    
    // 设置端口 - 默认5222
    _xmppStream.hostPort = 5222;
    
    
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        PPLog(@"%@",error);
    };

    PPLog(@"连接到服务器 -- ");
}


#pragma mark - 3.连接服务器成功, 发送密码授权
- (void)sendPasswordTohost
{
    PPLog(@"发送密码授权-- ");
    
    NSError *error = nil;
 
    // 从内存中获取 密码
    if(self.isRegisterOperation){ // 注册
        NSString *pwd = [PPUserInfo sharedPPUserInfo].registerPassword;
        
        // 注册 - 发送注册密码
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{ // 登录
        NSString *pwd = [PPUserInfo sharedPPUserInfo].password;
        
        // 登录 - 请求授权
        [_xmppStream authenticateWithPassword:pwd error:&error];
    }
  
    if (error) {
        PPLog(@"%@ ",error);
    };
}


#pragma mark - 4.授权成功以后, 发送在线消息
- (void)sendOnlineToHost
{
    PPLog(@"授权成功以后, 发送在线消息--");
    
    XMPPPresence *presence = [XMPPPresence presence];
    PPLog(@"presence - %@",presence);
    //
    [_xmppStream sendElement:presence];
}

//------------------------------- XMPPStreamDelegate ---------------------------------
#pragma mark - XMPPStreamDelegate
#pragma mark - 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    PPLog(@"与主机连接成功");
    
    // 与主机连接成功后, 发送密码进行授权
  
    [self sendPasswordTohost];

}


#pragma mark - 与主机连接错误
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    // 如果有错, 代表连接失败
    if(error && _resultBlock){
        
        _resultBlock(XMPPResultTypeNetError);
        
        PPLog(@"与主机断开连接%@",error);
    }else{  // 如果没有错误, 是人为断开的连接
        PPLog(@"人为断开了连接");
    }
}


#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    LogRed(@"注册成功");
    // 回调控制器 - 注册成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark - 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    if (error) {
        LogGreen(@"注册失败 -- %@",error);
        // 回调控制器 - 注册成功
        if(_resultBlock){
            _resultBlock(XMPPResultTypeRegisterFailure);
        }
    }
}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    PPLog(@"授权成功-- ");
    
    // 发送在线消息
    [self sendOnlineToHost];
    
    // 回调控制器 - 登录成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}


#pragma mark - 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    // 失败提示
    if (error) {
        PPLog(@"授权失败 %@-- ", error);
    }
    
    // 判断block 有无值 , 有值再回调
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

// ---------------------------------  公共方法  ----------------------------------------
#pragma mark - 公共方法
#pragma mark - 登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock
{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 登录之前 断开连接
    [_xmppStream disconnect];
    
    // 连接到主机
    [self connectToHost];
}


#pragma mark - 注销
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock
{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 登录之前 断开连接
    [_xmppStream disconnect];
    
    // 连接到主机
    [self connectToHost];
    
}


#pragma mark - 注销
- (void)xmppUserSignOut
{
    // 0. 更新用户登录状态
    [PPUserInfo sharedPPUserInfo].loginStatus = NO;
    // ****  每次跟新 必须保存
    [[PPUserInfo sharedPPUserInfo] saveUserInfoToSandbox];
    
    
    // 1. 发送 离线 消息
    XMPPPresence *signOut = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:signOut];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    // 3. 回到登陆界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.window.rootViewController = storyboard.instantiateInitialViewController;
    

    PPLog(@"注销");
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    
//    self.window.rootViewController = [[ViewController alloc] init];
//    
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
        [self xmppUserLogin:nil];
        
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
