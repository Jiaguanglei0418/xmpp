//
//  PPRegisterViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPRegisterViewController.h"
#import "PPLoginViewController.h"

@interface PPRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField; // 用户名
@property (weak, nonatomic) IBOutlet UITextField *pwdField; // 密码
@property (weak, nonatomic) IBOutlet UIButton *registerBtn; // 注册按钮


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RightConstraint;

@end

@implementation PPRegisterViewController


/**
 *  监听注册按钮点击
 */
- (IBAction)registerBtnClicked:(id)sender
{
    // 隐藏keyboard
    [self.view endEditing:NO];
    
    // 0. 判断手机号码
    if(![self.userField isTelphoneNum]){
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    // 1. 把用户注册信息 保存到单例中
    [PPUserInfo sharedPPUserInfo].registerUsername = self.userField.text;
    [PPUserInfo sharedPPUserInfo].registerPassword = self.pwdField.text;
    
   
    // 2. 调用AppDelegate的xmpp Register方法
    [XMPPTool sharedXMPPTool].registerOperation = YES;
    
    // 提示
    [MBProgressHUD showMessage:@"正在注册中..." toView:self.view];
    
    WS(selfVc);
    [[XMPPTool sharedXMPPTool] xmppUserRegister:^(XMPPResultType type) {
        // 处理请求结果 - 注册
        [selfVc handleResultType:type];
    }];
}


/**
 *  处理请求结果 - 提醒注册状态
 */
- (void)handleResultType:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{ // 在主线程刷新UI
        [MBProgressHUD hideHUDForView:self.view];
        
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
                // 返回到注册界面
                [self dismissViewControllerAnimated:YES completion:nil];
                
                // 设置登录界面label的text
                if([self.delegate respondsToSelector:@selector(PPRegisterViewControllerDidFinishRegister)]){
                    [self.delegate PPRegisterViewControllerDidFinishRegister];
                }
                
                break;
            case XMPPResultTypeRegisterFailure:
                
                [MBProgressHUD showError:@"注册失败: 用户名重复" toView:self.view];
                break;
                
            case XMPPResultTypeNetError:
                PPLog(@"注册失败 - 网络不给力");
                
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            default:
                break;
        }
    });
}


// 监听取消按钮点击
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置标题
    self.title = @"注册";
    
    // 判断当前设备的类型, 改变左右约束
    [self setupHorizonConstraint];
    
    // 设置textField 背景
    self.userField.background = [UIImage resizedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage resizedImageWithName:@"operationbox_text"];
    
    // 设置登录按钮背景
    [self.registerBtn SETBgStretchedImage:@"fts_green_btn" andHighlightedImage:@"fts_green_btn_HL"];

    
}


/**
 *  设置View 左右约束
 */
- (void)setupHorizonConstraint
{
    if (PP_UIDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        //iphone
        self.LeftConstraint.constant = 10;
        self.RightConstraint.constant = 10;
    }
}

/**
 *  设置 按钮不可用
 */
- (IBAction)textChanged:(id)sender {
    if ((self.userField.text != nil) && (self.pwdField.text != nil)) {
        self.registerBtn.enabled = YES;
    }
}


- (void)dealloc{
    LogYellow(@"");
}
@end
