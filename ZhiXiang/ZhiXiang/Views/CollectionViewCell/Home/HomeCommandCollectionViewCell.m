//
//  HomeCommandCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeCommandCollectionViewCell.h"

@implementation HomeCommandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createViews];
        
    }
    return self;
}

- (void)createViews
{
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
}

@end
