//
//  PPChatViewController.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
@interface PPChatViewController : UIViewController

// 好友Jid
@property (nonatomic, strong) XMPPJID *friendJid;
@end
