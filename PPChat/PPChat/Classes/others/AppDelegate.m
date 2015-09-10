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
    NSLog(@"初始化xmppStream-- %s",__FUNCTION__);
    
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
    XMPPJID *myJID = [XMPPJID jidWithUser:@"zhangsan" domain:@"localhost" resource:@"iPhone"];
    _xmppStream.myJID = myJID;

    // 设置服务器的域名
    _xmppStream.hostName = @"localhost"; // IP也可以
    
    // 设置端口 - 默认5222
    _xmppStream.hostPort = 5222;
    
    
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"%@",error);
    };
    
    NSLog(@"连接到服务器 -- %s",__FUNCTION__);
}


#pragma mark - 3.连接服务器成功, 发送密码授权
- (void)sendPasswordTohost
{
    NSLog(@"发送密码授权-- %s",__FUNCTION__);
    
    NSError *error = nil;
    
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if (error) {
        NSLog(@"%@ - %s",error,__FUNCTION__);
    };
}


#pragma mark - 4.授权成功以后, 发送在线消息
- (void)sendOnlineToHost
{
    NSLog(@"授权成功以后, 发送在线消息-- %s",__FUNCTION__);
    
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"presence - %@",presence);
    //
    [_xmppStream sendElement:presence];
}

//------------------------------- XMPPStreamDelegate ---------------------------------
#pragma mark - XMPPStreamDelegate
#pragma mark - 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功%s",__FUNCTION__);
    
    // 与主机连接成功后, 发送密码进行授权
    [self sendPasswordTohost];
}


#pragma mark - 与主机连接错误
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    // 如果有错, 代表连接失败
    if(error){
        NSLog(@"与主机断开连接%@",error);
    }
}


#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功-- %s",__FUNCTION__);
    
    // 发送在线消息
    [self sendOnlineToHost];
}

#pragma mark - 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if (error) {
        NSLog(@"授权失败 %@-- %s", error, __FUNCTION__);
    }
}

// ---------------------------------  公共方法  ----------------------------------------
#pragma mark - 公共方法
#pragma mark - 注销
- (void)signOut
{
    // 1. 发送 离线 消息
    XMPPPresence *signOut = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:signOut];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    NSLog(@"注销%s",__FUNCTION__);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[ViewController alloc] init];
    
    // 程序一启动就连接到主机
    [self connectToHost];
    
    [self.window makeKeyAndVisible];
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
