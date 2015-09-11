//
//  UIButton+setBg.h
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (setBg)

// 设置btn 正常和高亮状态下的背景图片
- (void)SETBgImage:(NSString *)normalImage andHighlightedImage:(NSString *)highlightedImage;


// 设置拉伸
- (void)SETBgStretchedImage:(NSString *)normalImage andHighlightedImage:(NSString *)highlightedImage;

@end
