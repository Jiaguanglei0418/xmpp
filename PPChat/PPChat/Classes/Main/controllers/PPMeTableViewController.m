//
//  PPMeTableViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPMeTableViewController.h"
#import "XMPPvCardTemp.h"

@interface PPMeTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;// 头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;// 名称
@property (weak, nonatomic) IBOutlet UILabel *WXAccount;// 微信号

@end

@implementation PPMeTableViewController

/**
 *  注销
 */
- (IBAction)signOutBtn:(id)sender {

    // 注销
    [[XMPPTool sharedXMPPTool] xmppUserSignOut];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取当前用户的信息 -- coreData
    // 1. 上下文[关联数据库]
    // 2. fetchRequest
    // 3. 过滤和排序
    // 4. 执行请求
    
    // xmpp框架直接获取个人信息
    XMPPvCardTemp *myvCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if (myvCard.photo) {
        self.headerImageView.image = [UIImage imageWithData:myvCard.photo];
    }
    
    // 设置昵称
    self.nickNameLabel.text = myvCard.nickname;
    
    // 设置微信号[用户名]
    self.WXAccount.text = [NSString stringWithFormat:@"微信号: %@",[PPUserInfo sharedPPUserInfo].username];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}




@end
