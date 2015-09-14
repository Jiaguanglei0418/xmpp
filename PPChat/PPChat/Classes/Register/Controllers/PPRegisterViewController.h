//
//  PPRegisterViewController.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPRegisterViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
- (void)PPRegisterViewControllerDidFinishRegister;

@end

@interface PPRegisterViewController : UIViewController

@property (nonatomic, weak) id<PPRegisterViewControllerDelegate> delegate;

@end
