//
//  PPOtherLoginViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
// 用户登录成功后, 如果关闭app, 重新启动 如果没有注销, 直接进入主页

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
    
    // 执行登录
    [super login];
    
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
