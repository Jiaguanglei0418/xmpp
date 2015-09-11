//
//  UIButton+setBg.m
//  PPChat
//
//  Created by jiaguanglei on 15/9/11.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "UIButton+setBg.h"


@implementation UIButton (setBg)

- (void)SETBgImage:(NSString *)normalImage andHighlightedImage:(NSString *)highlightedImage
{
    [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
}

- (void)SETBgStretchedImage:(NSString *)normalImage andHighlightedImage:(NSString *)highlightedImage
{
    [self setBackgroundImage:[UIImage resizedImageWithName:normalImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage resizedImageWithName:highlightedImage] forState:UIControlStateHighlighted];

}

@end
