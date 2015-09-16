//
//  PPContactTableViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPContactTableViewController.h"
#import "PPChatViewController.h"

@interface PPContactTableViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultCon;// 监听好友列表数据库
    XMPPUserCoreDataStorageObject *_friend;// 好友对象

}
@property (nonatomic, strong) NSArray *friends;
@end

@implementation PPContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取好友列表
    [self loadContacts2];
    
    
}



- (void)loadContacts2
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
    _resultCon = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理
    _resultCon.delegate = self;
    
    NSError *error = nil;
    [_resultCon performFetch:&error];
    if (error) {
        LogGreen(@"error = %@",error);
    }
//    LogOrange(@"friends - %@",_resultCon.fetchedObjects);
}

/**
 *  好友列表不实时更新

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
    
    // 4. 执行请求数
    self.friends = [context executeFetchRequest:request error:nil];
    
    //    LogCyan(@"%@",self.friends);
    
}
 */


#pragma mark - NSFetchedResultsControllerDelegate 监听数据库的内容发生改变
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
//    LogRed(@"数据库数据发生改变了");
    
    // 刷新表格
    [self.tableView reloadData];
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
    return _resultCon.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  sectionNum
     "0"  --  在线
     "1"  --  离开
     "2"  --  离线
     */
    static NSString *ID = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    // 获取好友
//    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];

    //即时更新
    _friend = _resultCon.fetchedObjects[indexPath.row];
    
    // 判断好友在线状态
    switch ([_friend.sectionNum integerValue]) {// 当需要设置模式为 rightDetail
        case 0: // 在线
            cell.detailTextLabel.text = @"在线";
            break;
        case 1: // 离开
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = _friend.jidStr;
    
    return cell;
}


#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 获取好友
    _friend = _resultCon.fetchedObjects[indexPath.row];
    
    // 选中cell 跳转
    [self performSegueWithIdentifier:@"chatSegue" sender:_friend.jid];
}

/**
 *  实现这个方法 - 侧滑显示删除
 *
 *  @param editingStyle <#editingStyle description#>
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
//        LogRed(@"删除好友");
        
        // 删除好友
        [[XMPPTool sharedXMPPTool].roster removeUser:_friend.jid];
    }
}

#pragma mark - 跳转 - 传friendJid
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[PPChatViewController class]]) {
        PPChatViewController *chatVc = destVc;
        
        chatVc.friendJid = sender;
    }
}

@end
