//
//  HomeDetailView.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

extern CGFloat HomeDetailViewShowAnimationDuration;
extern CGFloat HomeDetailViewHiddenAnimationDuration;

@interface HomeDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame andData:(HomeViewModel *)model;

- (void)becomeScreenToRead;

- (void)endScrrenToShow;

@end
