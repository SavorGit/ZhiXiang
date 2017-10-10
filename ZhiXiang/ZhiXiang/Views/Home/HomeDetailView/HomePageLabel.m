//
//  HomePageLabel.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomePageLabel.h"

@implementation HomePageLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 0, 0, 2};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
