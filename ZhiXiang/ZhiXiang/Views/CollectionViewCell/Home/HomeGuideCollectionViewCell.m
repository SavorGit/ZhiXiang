//
//  HomeGuideCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeGuideCollectionViewCell.h"
#import "ZXTools.h"

@interface HomeGuideCollectionViewCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * fromLabel;
@property (nonatomic, strong) UILabel * nextPageLabel;

@end

@implementation HomeGuideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createViews];
        
    }
    return self;
}

- (void)createViews
{
    self.backgroundColor = UIColorFromRGB(0x333333);
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    
    CGFloat scale = self.frame.size.height / 500.f;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = kPingFangMedium(17);
    self.titleLabel.textColor = UIColorFromRGB(0xfefefe);
    self.titleLabel.text = @"您已读完今日10条知享";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60 * scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.font = kPingFangLight(16);
    self.detailLabel.textColor = UIColorFromRGB(0xd3d3d3);
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = @"土地是以它的肥沃和收获而被估价的；才能也是土地，不过它生产的不是粮食，而是真理。如果只能滋生瞑想和幻想的话，即使再大的才能也只是砂地或盐池，那上面连小草也长不出来的。";
    [self.contentView addSubview:self.detailLabel];
    
    CGFloat height = [ZXTools getHeightByWidth:self.frame.size.width - 56 title:self.detailLabel.text font:kPingFangLight(16)];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(80 * scale);
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.height.mas_equalTo(height);
    }];
    
    self.fromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fromLabel.textAlignment = NSTextAlignmentRight;
    self.fromLabel.font = kPingFangLight(16);
    self.fromLabel.textColor = UIColorFromRGB(0xd3d3d3);
    self.fromLabel.text = @"———— 别林斯基";
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(35 * scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(16);
    }];
    
    self.nextPageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nextPageLabel.textAlignment = NSTextAlignmentRight;
    self.nextPageLabel.font = kPingFangRegular(15);
    self.nextPageLabel.textColor = UIColorFromRGB(0x999999);
    self.nextPageLabel.text = @"滑动阅读昨日知享→";
    [self.contentView addSubview:self.nextPageLabel];
    [self.nextPageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
}

@end
