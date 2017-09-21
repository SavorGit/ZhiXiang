//
//  HeaderTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HeaderTableViewCell.h"

@interface HeaderTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *sourceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation HeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = kPingFangMedium(22);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"标题";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(31);
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
    }];
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.text = @"小热点";
    _sourceLabel.font = kPingFangLight(11);
    _sourceLabel.textColor = UIColorFromRGB(0x8a8886);
    [self addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(_titleLabel.mas_bottom).offset(16);
        make.left.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"2017-09-20";
    _timeLabel.font = kPingFangLight(10);
    _timeLabel.textColor = UIColorFromRGB(0xb2afab);
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.mas_equalTo(_titleLabel.mas_bottom).offset(16);
        make.left.equalTo(_sourceLabel.mas_right).offset(10);
    }];
    
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
    
    CGFloat titleHeight = [self getHeightByWidth:kMainBoundsWidth - 30 title:model.title font:kPingFangMedium(22)];
    if (titleHeight > 31) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(62);
        }];
    }else{
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(31);
        }];
    }
    self.titleLabel.text = model.title;
    _sourceLabel.text = @"小热点";
    _timeLabel.text = @"2017-09-20";
    
}

@end
