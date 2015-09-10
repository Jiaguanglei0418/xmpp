//
//  ViewController.h
//  02-xmpp框架
//
//  Created by jiaguanglei on 15/9/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//
/**
 *  xmpp框架
 
 vendor:
 1. CocoaAsyncSocket - 底层网络框架
 2. CocoaLumberjack - 日志框架
 3. kissXML 
    ->3.1 libxml2.dylib (动态库)
    ->3.3 header search path + /usr/include/libxml2;
    ->3.3 other linker flags + lxml2;
 4. libidn
 
 * Authentication - 授权
 * Categories - 分类
 * Core - 核心
 
     XMPPStream  - 交互
     XMPPParser  - 解析
     XMPPJID     - 不可变(QQ号)
     XMPPElement - 基类
     XMPPIQ      - 请求
     XMPPMessage - 消息
     XMPPPresence- 出席
     XMPPModule  - 开发xmpp扩展用
     XMPPLogging - 日志
     XMPPInternal- 核心底层
 
 
 * Utilities - 工具
 * 依赖库: libresolv.dylib
 
 
 * Extensions - 扩展
 
 */
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

