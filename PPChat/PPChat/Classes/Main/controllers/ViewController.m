//
//  ViewController.m
//  02-xmpp框架
//
//  Created by jiaguanglei on 15/9/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor lightGrayColor];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取AppDelegate 对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    // 注销
//    [app signOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
