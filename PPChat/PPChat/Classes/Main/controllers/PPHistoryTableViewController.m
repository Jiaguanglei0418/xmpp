//
//  PPHistoryTableViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHistoryTableViewController.h"

@interface PPHistoryTableViewController ()

// 菊花 - indicatorView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation PPHistoryTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 注册 监听indicatorView的通知
    [PP_NOTICEFICATIONCENTER addObserver:self selector:@selector(loginStatusChange:) name:PPLoginStatusChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


#pragma mark - 监听网络请求状态的通知
- (void)loginStatusChange:(NSNotification *)notice
{
    // 通知是在子线程被调用的, 刷新UI需要在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
//        LogRed(@"%@",notice.userInfo);
        
        // 获取登录状态
        int status = [notice.userInfo[@"loginStatus"] intValue];
        
        switch (status) {
            case XMPPResultTypeConnecting: // 正在连接
                [self.indicatorView startAnimating];
                break;
            case XMPPResultTypeNetError: //与服务器连接失败
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginSuccess: // 登录成功
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginFailure: // 登录失败
                [self.indicatorView stopAnimating];
                break;
            default:
                break;
        }
    });
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
