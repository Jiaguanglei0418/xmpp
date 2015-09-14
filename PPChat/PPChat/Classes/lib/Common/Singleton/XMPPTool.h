//
//  XMPPTool.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

// -----   xmpp 抽取的工具类 : 注册 , 登录 , 注销等与服务器交互工作

/**
 *  在AppDelegate中实现登录
 
 1. 初始化xmppStream
 2. 连接到服务器(传一个JID)
 3. 连接服务器成功, 发送密码授权
 4. 授权成功以后, 发送在线消息
 */

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

typedef enum {
    XMPPResultTypeLoginSuccess, // 登录成功
    XMPPResultTypeLoginFailure, // 失败
    XMPPResultTypeNetError, // 网络不给力
    XMPPResultTypeRegisterSuccess, // 注册成功
    XMPPResultTypeRegisterFailure  // 注册失败
}XMPPResultType;

typedef void (^XMPPResultBlock) (XMPPResultType type); // 登录请求结果block

@interface XMPPTool : NSObject


singleton_interface(XMPPTool)

@property (nonatomic, strong) XMPPvCardTempModule *vCard;//电子名片 - 便于meCon 调用

@property (nonatomic, strong) XMPPReconnect *reconnect;//自动连接模块

@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;// 花名册 - 数据存储;



/**
 *  注册标识  yes - 注册  no - 登录
 */
@property (nonatomic, assign, getter=isRegisterOperation) BOOL registerOperation;


/**
 *  用户登录
 */
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/**
 *  注销
 */
- (void)xmppUserSignOut;

/**
 *  用户注册
 */
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock;


@end
