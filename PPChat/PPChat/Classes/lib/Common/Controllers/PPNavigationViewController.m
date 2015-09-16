//
//  PPNavigationViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPNavigationViewController.h"

@interface PPNavigationViewController ()

@end

@implementation PPNavigationViewController

/**
 *  一个类只调用一次
 */
+ (void)initialize
{
    [self setupTheme];
}


/**
 *  设置导航栏的主题
 */
+ (void)setupTheme
{
    // 设置导航栏样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 1. 设置导航条的背景
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 2. 设置导航条的字体
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];

    [navBar setTitleTextAttributes:attrs];
    
    // 3. 设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
}

// 如果, 控制器是由导航控制器管理, 设置状态栏的样式需要在导航控制器中设置  -- 采用plist设置
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/**
 *  拦截push, 每次跳转之后,都会隐藏tabBar
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
