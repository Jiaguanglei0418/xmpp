//
//  PPEditProfileViewController.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPEditProfileViewControllerDelegate <NSObject>

- (void)editProfileViewControllerDidSave;

@end

@interface PPEditProfileViewController : UITableViewController

// 更新服务器端数据
@property (nonatomic, weak) id<PPEditProfileViewControllerDelegate> delegate;


// 设置cell
@property (nonatomic, strong) UITableViewCell *cell;

@end
