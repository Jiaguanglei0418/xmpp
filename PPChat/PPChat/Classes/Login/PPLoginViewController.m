//
//  PPLoginViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPRegisterViewController.h"
#import "PPNavigationViewController.h"

@interface PPLoginViewController ()<PPRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UITextField *pwdField; // 密码
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn; // 登录按钮


@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置textfield 和 btn的样式
    [self setupSubviews];
    
    // 设置用户名为上次登录的用户名 - 单利
    self.userLabel.text = [PPUserInfo sharedPPUserInfo].username;
    
    
}


/**
 *  设置textfield 和 btn的样式
 */
- (void)setupSubviews
{
    // textField 背景
    self.pwdField.background = [UIImage resizedImageWithName:@"operationbox_text"];
    
    // leftView
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    // Loginbtn
    [self.LoginBtn SETBgStretchedImage:@"fts_green_btn" andHighlightedImage:@"fts_green_btn_HL"];
}


/**
 *  监听登录
 */
- (IBAction)LoginBtnClicked:(id)sender {
    // 1. 保存数据到单利中
    PPUserInfo *userInfo = [PPUserInfo sharedPPUserInfo];
    
    userInfo.username = self.userLabel.text;
    userInfo.password = self.pwdField.text;
    
    // 2. 调用父类的登录
    [super login];
}


/**
 *  从storyboard 获取控制器的方法
 *****  注意: 获取到的控制器是导航控制器, 还是视图控制器
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 获取注册控制器 (此处获得的是导航控制器)
    id destVc = segue.destinationViewController;
    
    PPNavigationViewController *nav = destVc;
    
    // 获取根控制器
    PPRegisterViewController *registerVc = (PPRegisterViewController *)nav.topViewController;
    if ([registerVc isKindOfClass:[PPRegisterViewController class]]) {

        // 设置注册控制器
        registerVc.delegate = self;
    }
}


#pragma mark - PPRegisterViewControllerDelegate
- (void)PPRegisterViewControllerDidFinishRegister
{
    LogBlue(@"完成注册");
    
    // 完成注册 , 显示注册的用户名 - 主线程
    self.userLabel.text = [PPUserInfo sharedPPUserInfo].registerUsername;
    
    [MBProgressHUD showSuccess:@"请登录" toView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
