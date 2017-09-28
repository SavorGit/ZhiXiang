//
//  HomeStatusCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeStatusCollectionViewCell.h"
#import "DGActivityIndicatorView.h"

@interface HomeStatusCollectionViewCell ()

@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) DGActivityIndicatorView *loadingView;
@property (nonatomic, strong) UITapGestureRecognizer * tap;

@end

@implementation HomeStatusCollectionViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bgImageView setImage:[UIImage imageNamed:@"liebiaotuzhanwei"]];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(100, 100 * 45 / 70));
    }];
    
    self.loadingView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:UIColorFromRGB(0x111111) size:30];
    self.loadingView.frame = CGRectMake(0, 0, 100, 30);
    [self.contentView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(self.loadingView.frame.size);
    }];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.text = @"";
    self.statusLabel.font = kPingFangRegular(13);
    self.statusLabel.textColor = UIColorFromRGB(0x111111);
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    self.statusLabel.hidden = YES;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retry)];
    self.tap.numberOfTapsRequired = YES;
    [self.contentView addGestureRecognizer:self.tap];
}

-  (void)showLoading
{
    self.tap.enabled = NO;
    [self.loadingView startAnimating];
    self.statusLabel.hidden = YES;
}

- (void)showNoMoreData
{
    self.tap.enabled = NO;
    self.statusLabel.text = @"您已看完全部内容";
    
    [self.loadingView stopAnimating];
    self.statusLabel.hidden = NO;
}

- (void)showNoNetWork
{
    self.tap.enabled = YES;
    self.statusLabel.text = @"网络连接失败，点击重试";
    
    [self.loadingView stopAnimating];
    self.statusLabel.hidden = NO;
}

- (void)retry
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomeStatusDidBeRetryLoadData)]) {
        [self.delegate HomeStatusDidBeRetryLoadData];
    }
}

@end
