//
//  SpecialHeaderView.m
//  SavorX
//
//  Created by 王海朋 on 2017/8/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SpecialHeaderView.h"
#import "UIImageView+WebCache.h"

@interface SpecialHeaderView ()

@property (nonatomic, copy) NSString * imageURL;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, assign) CGFloat maxImageHeight;
@property (nonatomic, assign) CGFloat minImageHeight;

@property (nonatomic, assign) CGFloat maxTitleHeight;
@property (nonatomic, assign) CGFloat minTitleHeight;

@end

@implementation SpecialHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.maxImageHeight =  kMainBoundsWidth / 750.f * 488.f;
    self.minImageHeight = (kMainBoundsWidth - 60) / 750.f * 488.f;
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.frame = CGRectMake(0, 0, kMainBoundsWidth, self.minImageHeight);
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
//    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kMainBoundsWidth);
////        make.height.equalTo(_bgImageView.mas_width).multipliedBy(802.f/1242.f);//222.5
//        make.height.mas_equalTo(imageHeight/2);
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(15, self.minImageHeight + 20, kMainBoundsWidth - 30, 31);
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = kPingFangMedium(22);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"标题";
    [self addSubview:_titleLabel];
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kMainBoundsWidth - 30);
//        make.height.mas_equalTo(31);
//        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(20);
//        make.left.mas_equalTo(15);
//    }];
    
//    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
//        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
//        make.left.mas_equalTo(15);
//    }];
    
}

- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (void)configModelData:(HomeViewModel *)model{
    
    self.maxTitleHeight = [self getHeightByWidth:kMainBoundsWidth - 30 title:model.title font:kPingFangMedium(22)];
    self.minTitleHeight = [self getHeightByWidth:kMainBoundsWidth - 30 - 60 title:model.title font:kPingFangMedium(22)];
    CGFloat maxHeight = 31;
    if (self.minTitleHeight > 31) {
        maxHeight = 62;
//        _titleLabel.frame = CGRectMake(15, _imageHeight/2 + 20, kMainBoundsWidth - 30, 62);
//        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(62);
//        }];
    }else{
        maxHeight = 31;
//        _titleLabel.frame = CGRectMake(15, _imageHeight/2 + 20, kMainBoundsWidth - 30, 31);
//        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(31);
//        }];
    }
    _titleLabel.frame = CGRectMake(15, self.minImageHeight + 20, kMainBoundsWidth - 30, maxHeight);
    self.titleLabel.text = model.title;
    
    if ([self.imageURL isEqualToString:model.imageURL]) {
        return;
    }
    self.imageURL = model.img_url;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
    self.frame = CGRectMake(0, 0, kMainBoundsWidth - 60, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 25);
}

- (void)startScrShow
{
    _titleLabel.frame = CGRectMake(15, self.maxImageHeight + 20, kMainBoundsWidth - 30, self.maxTitleHeight);
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 25);
    self.bgImageView.frame = CGRectMake(0, 0, kMainBoundsWidth, self.maxImageHeight);
    
}

- (void)endScrShow{
    _titleLabel.frame = CGRectMake(15, self.minImageHeight + 20, kMainBoundsWidth - 30 - 60, self.minTitleHeight);
    self.frame = CGRectMake(0, 0, kMainBoundsWidth - 60, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 25);
    self.bgImageView.frame = CGRectMake(0, 0, kMainBoundsWidth - 60, self.minImageHeight);
}

@end
