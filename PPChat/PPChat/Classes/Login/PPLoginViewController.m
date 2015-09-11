//
//  PPLoginViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPLoginViewController.h"

@interface PPLoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLabel;


@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置用户名为上次登录的用户名 - 单利
    self.userLabel.text = [PPUserInfo sharedPPUserInfo].username;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
