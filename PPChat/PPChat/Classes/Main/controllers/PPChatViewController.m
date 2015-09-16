//
//  PPChatViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPChatViewController.h"
#import "PPChatInputView.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
@interface PPChatViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultCon;// 执行查询数据 (实时更新)
}
@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView 键盘frame改变的时候 改变约束
@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView 高度约束

@property (nonatomic, weak) UITableView *tableView;;

@property (nonatomic, strong) HttpTool *httpTool; // 上传文件工具类 - 单利
@end

@implementation PPChatViewController

- (HttpTool *)httpTool{
    if (!_httpTool) {
        _httpTool = [[HttpTool alloc] init];
    }
    return _httpTool;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 代码方式实现自动布局 VFL
    [self setupView];
    
    
    // 监听键盘  --  这种监听方式 在ios7中有bug, inputViewY 被键盘挡住(键盘的y为0)
//    [PP_NOTICEFICATIONCENTER addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [PP_NOTICEFICATIONCENTER addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [PP_NOTICEFICATIONCENTER addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    // 加载数据
    [self loadMsgs];
    
    // 滚动到底部
    [UIView animateWithDuration:.5 animations:^{
        [self scrollToTableBottom];
    }];
}


/**
 *  监听键盘frame改变
 */
- (void)keyboardDidShow:(NSNotification *)notice
{
    // 键盘结束的frame
    CGRect kbEndFrame = [notice.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 取出键盘的高度
    CGFloat kbH = kbEndFrame.size.height;
    
 /*   // 设置约束
//    [fg255,0,255;kbEndFrame -- {{0, 377}, {1024, 391}} -- show[; - 横屏
//     [fg255,0,255;kbEndFrame -- {{0, 768}, {1024, 391}} -- hide[;
//       [fg255,0,255;kbEndFrame -- {{0, 721}, {768, 303}} -- show[; - 竖屏
//       [fg255,0,255;kbEndFrame -- {{0, 1024}, {768, 303}} -- hide[;
 */
    
    if([PP_UIDevice.systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        kbH = kbEndFrame.size.width;
    }
    
    self.inputViewBottomConstraint.constant = kbH;
    
    // 滚动到底部
//    WS(selfVc);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 animations:^{
            [self scrollToTableBottom];
        }];
    });
    
}

/**
 *  键盘隐藏代理方法实现
 */
- (void)keyboardDidHide:(NSNotification *)notice
{
    // 键盘结束的frame
//    CGRect kbEndFrame = [notice.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    LogMagenta(@"kbEndFrame -- %@ -- hide",NSStringFromCGRect(kbEndFrame));
   
    // 键盘隐藏, inputView距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
}


/**
 *  监听键盘frame改变

//- (void)keyboardFrameChange:(NSNotification *)notice
//{
////    LogYellow(@"%@",notice.userInfo);
//    
//    // 获取窗口的高度
//    CGFloat windowH = PP_SCREEN_HEIGHT;
//    
//    // 键盘结束的frame
//    CGRect kbEndFrame = [notice.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    // 取出键盘的y值
//    CGFloat kbY = kbEndFrame.origin.y;
//    
//    // 设置约束
//    self.inputViewConstraint.constant = windowH - kbY;
//}
 */

/**
 *  设置tableView 和 inputView
 */
- (void)setupView
{   // 代码的方式 实现自动布局
    // 1. 创建tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.bounces = NO;
    
    // 设置代理
    tableView.dataSource = self;
    tableView.delegate = self;
#warning 代码实现约束, 要设置下面属性为no
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 注册cell
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    // 2. 创建输入框
    PPChatInputView *inputView = [PPChatInputView inputView];
#warning 代码实现约束, 要设置下面属性为no
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 设置代理
    inputView.textView.delegate = self;
    
    // 监听添加按钮点击
    [inputView.addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:inputView];
    
    
    // 3. 自动布局
    // 3.1 水平方向约束
    // tableView
    NSDictionary *views = @{@"tableView":tableView , @"inputView":inputView};
    // @"H:-0-[tableView]-0-|" ---- tableView 距离父控件 左右都为0
    NSArray *tableViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHConstraints];
    
    // inputView
    // @"H:-0-[tableView]-0-|" ---- tableView 距离父控件 左右都为0
    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstraints];
    
    // 3.2 垂直方向约束
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vConstraints];
    
    // inputView的高度约束
    self.inputViewHeightConstraint = vConstraints[2];
    
    // 获取inputView底部约束
    self.inputViewBottomConstraint = [vConstraints lastObject];
//    LogPurple(@"%@",vConstraints);
}


#pragma mark - 发送图片
- (void)addBtnClicked
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;

    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - 实现图片代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    LogRed(@"%@",info);
    
    // 获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 把图片发送到文件服务器
    // 文件上传路径: http://localhost:8080/imfileserver/Upload/Image/+[图片名]
    /**
     *  http put POST
     *
     *  @put 实现文件上传没有POST繁琐, 而且比POST快
     *  @put 文件上传路径就是下载路径
     */
    // 1. 取文件名 用户名 + 时间
    NSString *username = [PPUserInfo sharedPPUserInfo].username;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *filename = [username stringByAppendingString:dateStr];
    
    // 2. 拼接上传路径
    NSString *uploadUrl = [NSString stringWithFormat:@"http://localhost:8080/imfileserver/Upload/Image/%@",filename];
    
    // 3. 使用HTTP put 上传
#warning 图片上传 请使用jpg格式
    [self.httpTool uploadData:UIImageJPEGRepresentation(image, 1.0) url:[NSURL URLWithString:uploadUrl] progressBlock:nil completion:^(NSError *error) {
        if (!error) {
            LogRed(@"上传成功");
        }
    }];
    
    // 图片发送成功, 把图片的URL传给Openfire服务器
    [self sendMsgWithText:uploadUrl bodyType:@"image"];
}


#pragma mark - UITextViewDelegate  -- 发送消息
// send - 监听换行
- (void)textViewDidChange:(UITextView *)textView
{
    // 获取contentSize
    CGFloat contentH = textView.contentSize.height;
    
    // 1行 - 3行的高度
    if(contentH > 33 && contentH < 68){
        self.inputViewHeightConstraint.constant = contentH + 18;
    }
    
    NSString *text = textView.text;
    
    if ([text rangeOfString:@"\n"].length) {
        // 去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // 发送消息 - 文本消息
        [self sendMsgWithText:text bodyType:@"text"];
        
        // 清空数据
        textView.text = nil;
        
        // 发送完消息, 改变inputView的高度
        self.inputViewHeightConstraint.constant = 50;
    }
}


#pragma mark - 发送消息
- (void)sendMsgWithText:(NSString *)text bodyType:(NSString *)type
{
    // 封装成xml数据
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    // text - 纯文本  image - 图片
    [msg addAttributeWithName:@"bodyType" stringValue:type];
    
    // 设置内容
    [msg addBody:text];
    
    [[XMPPTool sharedXMPPTool].xmppStream sendElement:msg];
}

#pragma mark - 加载XMPPMessageArchiving数据 显示 --- 聊天模块
- (void)loadMsgs
{
    // 1. 上下文
    NSManagedObjectContext *context = [XMPPTool sharedXMPPTool].msgStorage.mainThreadManagedObjectContext;
    
    // 2. 请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 3. 过滤 排序
    // 3.1 当前登录用户的jid
    // 3.2 好友的jid
//    NSString *friendJid = nil;
    // bare -- usr@localhost
    // user -- username
//    LogYellow(@"friendJid = %@",self.friendJid);
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[PPUserInfo sharedPPUserInfo].JID,self.friendJid.bare];
//    LogYellow(@"%@",pre);
    request.predicate = pre;
    
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4. 执行请求
    _resultCon = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理
    _resultCon.delegate = self;
    
    NSError *error = nil;
    [_resultCon performFetch:&error];
    if (error) {
        LogGreen(@"error = %@",error);
    }
}


#pragma mark ResultController的代理
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 刷新数据
    [self.tableView reloadData];
    [self scrollToTableBottom];
}

#pragma mark 滚动到底部
- (void)scrollToTableBottom{
    NSInteger lastRow = _resultCon.fetchedObjects.count - 1;
    
    // 如果行数小于1, 不允许滚动
    if(lastRow < 1){
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultCon.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"chatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultCon.fetchedObjects[indexPath.row];
    
    // 判断是图片还是纯文本
    NSString *bodyType = [msg.message attributeStringValueForName:@"bodyType"];

    if ([bodyType isEqualToString:@"image"]) {
        // 下载图片
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:[UIImage imageNamed:@"DefaultProfileHead"]];
        cell.textLabel.text = nil;
    }else{
        // 显示文本
        if ([msg.outgoing boolValue]) { // 自己发的
            cell.textLabel.text = [NSString stringWithFormat:@"me:%@",msg.body];
        }else{ // 好友发的
            cell.textLabel.text = [NSString stringWithFormat:@"other:%@",msg.body];
        }
        cell.imageView.image = nil;
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [PP_NOTICEFICATIONCENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [PP_NOTICEFICATIONCENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    LogRed(@"%s",__FUNCTION__);
}

@end
