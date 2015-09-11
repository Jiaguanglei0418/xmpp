//
//  PPOtherLoginViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPOtherLoginViewController.h"
#import "AppDelegate.h"


@interface PPOtherLoginViewController ()

// View距离屏幕左边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftConstraint;

// View距离屏幕右边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RightConstraint;


@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;

@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation PPOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.title = @"其他方式登录";
    
    // 判断当前设备的类型, 改变左右约束
    [self setupHorizonConstraint];
    
    // 设置textField 背景
    self.userField.background = [UIImage resizedImageWithName:@"operationbox_text"];
    self.pswField.background = [UIImage resizedImageWithName:@"operationbox_text"];
    // 设置登录按钮背景
    [self.LoginBtn SETBgStretchedImage:@"fts_green_btn" andHighlightedImage:@"fts_green_btn_HL"];
    
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
 *  监听登录按钮
 */
- (IBAction)LoginBtnClicked:(id)sender
{
    // 键盘弹回
    [self.view endEditing:YES];
    
    //官方的登录实现
    /**
     *  1. 把用户名和密码放在PPUserInfo的单利中
        2. 调用 AppDelegate中的 Login方法登录
     */
    PPUserInfo *userInfo = [PPUserInfo sharedPPUserInfo];
    
    userInfo.username = self.userField.text;
    userInfo.password = self.pswField.text;

    
    // 2. 调用AppDelegate connect 连接并登陆 --- 回调
    // 登录之前提示
    [MBProgressHUD showMessage:@"正在拼命登录中...." toView:self.view];
    
    AppDelegate *app = PP_UIApplication.delegate;
    
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


// 取消登录
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    PPLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
