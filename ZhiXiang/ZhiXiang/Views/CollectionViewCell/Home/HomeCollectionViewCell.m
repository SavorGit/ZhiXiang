//
//  HomeCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()

@property (nonatomic, strong) UIView * baseView;

@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createViews];
        
    }
    return self;
}

- (void)createViews
{
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.baseView.layer.cornerRadius = 10.f;
    self.baseView.layer.masksToBounds = YES;
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    
    self.baseView.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

@end
