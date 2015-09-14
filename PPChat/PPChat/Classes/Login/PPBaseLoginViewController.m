//
//  PPBaseLoginViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPBaseLoginViewController.h"
#import "AppDelegate.h"


@interface PPBaseLoginViewController ()

@end

@implementation PPBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

/**
 *  监听登录按钮
 */
- (void)login
{
    // 键盘弹回
    [self.view endEditing:YES];
    
    
    // 2. 调用AppDelegate connect 连接并登陆 --- 回调
    // 登录之前提示
    [MBProgressHUD showMessage:@"正在拼命登录中...." toView:self.view];
    
    AppDelegate *app = PP_UIApplication.delegate;

    // 注册标识 
    app.registerOperation = NO;
    
    
    WS(selfVc);
    
    [app xmppUserLogin:^(XMPPResultType type) {
        
        [selfVc handleResultType:type];
    }];
}


/**
 *  处理请求结果 - 提醒登录状态
 */
- (void)handleResultType:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{ // 在主线程刷新UI
        [MBProgressHUD hideHUDForView:self.view];
        
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                PPLog(@"登陆成功");
                
                [self enterMainPage];
                break;
            case XMPPResultTypeLoginFailure:
                PPLog(@"登陆失败");
                
                [MBProgressHUD showError:@"用户名或者密码不正确" toView:self.view];
                break;
                
            case XMPPResultTypeNetError:
                PPLog(@"登陆失败 - 网络不给力");
                
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            default:
                break;
        }
    });
}


/**
 *  跳转到主界面
 */
- (void)enterMainPage
{
    // 更新登录状态
    [PPUserInfo sharedPPUserInfo].loginStatus = YES;
    
    
    // 将登录成功的用户信息 - 保存到单利
    [[PPUserInfo sharedPPUserInfo] saveUserInfoToSandbox];
    
#warning 内存泄露 - 如果是通过modal出来的控制器 , 需要调用dismiss, 否则会内存泄露
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 授权成功 - 跳转到主界面
    // 获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // 获取storyboard 第一个控制器
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}

@end
