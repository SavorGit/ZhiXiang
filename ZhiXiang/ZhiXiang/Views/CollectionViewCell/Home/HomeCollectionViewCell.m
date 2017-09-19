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
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * bottoView;

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
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.baseView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.baseView.mas_height).multipliedBy(.5f);
    }];
    self.topView.backgroundColor = [UIColor blueColor];
    
    self.bottoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.baseView addSubview:self.bottoView];
    [self.bottoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
    }];
    self.bottoView.backgroundColor = [UIColor redColor];
}

@end
