//
//  PPAddContactViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPAddContactViewController.h"

@interface PPAddContactViewController ()<UITextFieldDelegate>

@end

@implementation PPAddContactViewController


/**
 *  代理监听 - 点击return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 添加好友
    // 1. 获取好友账号
    NSString *user = textField.text;
    LogRed(@"%@",user);
    
    // 2. 发送好友添加请求
//    if (![textField isTelphoneNum]) { // 判断手机号
//        // 提示
//        [self showAlert:@"用户名或者密码不正确"];
//    }
    
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,PP_DOMAIN];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    LogRed(@"zhanghao --  %@",jidStr);
    
    // 不能添加已经存在好友 \ 判断不能添加自己
    if ([user isEqualToString:[PPUserInfo sharedPPUserInfo].username]){
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }else if ([[XMPPTool sharedXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[XMPPTool sharedXMPPTool].xmppStream]){
        [self showAlert:@"好友已经存在"];
        return YES;
    }
    
    
    [[XMPPTool sharedXMPPTool].roster subscribePresenceToUser:friendJid];
    
    // 3.控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

/**
 *  提示 - alert
 */
- (void)showAlert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"提醒" message:msg delegate:self cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil] show];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    LogGreen(@"");
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 1;
//}

@end
