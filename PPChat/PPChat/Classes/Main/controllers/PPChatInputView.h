//
//  PPChatInputView.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPChatInputView : UIView

/**
 *  添加文件
 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

/**
 *  输入框
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;

/**
 *  快速创建对象
 */
+ (instancetype)inputView;
@end
