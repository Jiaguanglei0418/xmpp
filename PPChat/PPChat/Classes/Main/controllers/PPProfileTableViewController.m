//
//  PPProfileTableViewController.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPProfileTableViewController.h"
#import "XMPPvCardTemp.h"
#import "PPEditProfileViewController.h"

@interface PPProfileTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,PPEditProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel; // 昵称
@property (weak, nonatomic) IBOutlet UILabel *WXAccountLabel; //微信号

@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;  // 公司
@property (weak, nonatomic) IBOutlet UILabel *orgDepartLabel;// 部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel; // 电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel; // 邮箱


@end

@implementation PPProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    // 加载电子名片信息
    [self loadVCard];
    
}

/**
 *  加载电子名片信息
 */
- (void)loadVCard
{
    // xmpp框架直接获取个人信息
    XMPPvCardTemp *myvCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if (myvCard.photo) {
        self.headerImageView.image = [UIImage imageWithData:myvCard.photo];
    }
    
    // 设置昵称
    self.nicknameLabel.text = myvCard.nickname;
    
    // 设置微信号[用户名]
    self.WXAccountLabel.text = [NSString stringWithFormat:@"%@",[PPUserInfo sharedPPUserInfo].username];
    // 设置公司
    self.orgnameLabel.text = myvCard.orgName;
    // 设置部门
    self.orgDepartLabel.text = [myvCard.orgUnits firstObject];
    // 设置职位
    self.titleLabel.text = myvCard.title;
    // 设置电话
#warning myvCard.telecomsAddresses 此方法没有对mycardxml-数据进行解析
    self.phoneLabel.text = myvCard.note;
    // 邮件
#warning myvCard.telecomsAddresses 此方法没有对mycardxml-数据进行解析
//    self.emailLabel.text = myvCard.mailer;
    // 邮件解析
    if (myvCard.emailAddresses.count > 0) { // 不管有多少个邮箱只显示第一个
        self.emailLabel.text = [myvCard.emailAddresses firstObject];
    }
    
    // 保存
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 1. 获取cell.tag
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    // 2. 判断点击事件
    switch (cell.tag) {
        case 2: // 不做任何操作
            return;
        case 1: // 跳转到详情Con
            LogRed(@"跳转-----");
            
            // 跳转
            [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
            
            break;
        case 0: // 选择图片
        { LogRed(@"选着头像图片");
            // 对话框
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
            [sheet showInView:self.view];
            
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


/**
 *  通过segue 跳转的时候会调用此方法
 *
 *  @param segue  跳转控制点
 *  @param sender cell - 对象
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 获取个人信息控制
    id destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[PPEditProfileViewController class]]) {
        PPEditProfileViewController *editVc = destVc;
        
        // 设置代理
        editVc.delegate = self;
        
        // 正向传值
        editVc.cell = sender;
    }
}


#pragma mark - PPEditProfileViewControllerDelegate 编辑个人信息代理
- (void)editProfileViewControllerDidSave
{
    // 获取当前的电子名片信息
    XMPPvCardTemp *myVCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    // 昵称
    myVCard.nickname = self.nicknameLabel.text;
    
    // 公司
    myVCard.orgName = self.orgnameLabel.text;
    
    // 部门
    if (self.orgDepartLabel.text.length) {
        myVCard.orgUnits = @[self.orgDepartLabel.text];
    }
    
    // 职位
    myVCard.title = self.titleLabel.text;
    
    // 电话
    myVCard.note = self.phoneLabel.text;
    
    // 邮件
//    myVCard.mailer = self.emailLabel.text;
    if (myVCard.emailAddresses.count > 0) {
        // 保存
        myVCard.emailAddresses = @[self.emailLabel.text];
    }
    
    
    // 头像
    myVCard.photo = UIImagePNGRepresentation(self.headerImageView.image);
    
    // 更新 -- 此方法内部 会更新到服务器, 无须自己操作
    [[XMPPTool sharedXMPPTool].vCard updateMyvCardTemp:myVCard];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 设置代理
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 2) {// 取消
        return;
    }else if (buttonIndex == 0){ //照相
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{// 相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.headerImageView.image = image;
    
    // 隐藏当前窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 3. 更新到服务器
    
    
//    // 获取当前的电子名片信息
//    XMPPvCardTemp *vCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
//    
//    
//    // 更新 -- 此方法内部 会更新到服务器, 无须自己操作
//    [[XMPPTool sharedXMPPTool].vCard updateMyvCardTemp:vCard];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSArray *array = @[@[@"",@"",@""],@[@"",@"",@"",@"",@""]];
//    NSArray *rows = array[section];
    return [array[section] count];

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
