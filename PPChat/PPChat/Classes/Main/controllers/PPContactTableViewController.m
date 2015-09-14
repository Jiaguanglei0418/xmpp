//
//  PPContactTableViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPContactTableViewController.h"

@interface PPContactTableViewController ()
@property (nonatomic, strong) NSArray *friends;
@end

@implementation PPContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取好友列表
    [self loadContacts];
    
}



- (void)loadContacts
{
    // 使用coreData 获取好友列表
    // 1. 上下文 - 关联数据库
    NSManagedObjectContext *context = [XMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 2. FetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3. 过滤\排序
    // 过滤当前登录用户的好友
//    NSString *JID = [PPUserInfo sharedPPUserInfo].JID;

    // BEGINSWITH、ENDSWITH、CONTAINS
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr ENDSWITH %@",PP_DOMAIN];
    
    request.predicate = pre;
    
    // 排序 - displayName
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4. 执行请求数据
    self.friends = [context executeFetchRequest:request error:nil];
    
    LogCyan(@"%@",self.friends);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    // 获取好友
    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    
    cell.textLabel.text = friend.jidStr;
    
    return cell;
}
@end
