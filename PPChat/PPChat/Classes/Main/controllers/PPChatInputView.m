//
//  PPChatInputView.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPChatInputView.h"

@implementation PPChatInputView

+ (instancetype)inputView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PPChatInputView" owner:nil options:nil] lastObject];
}

@end
