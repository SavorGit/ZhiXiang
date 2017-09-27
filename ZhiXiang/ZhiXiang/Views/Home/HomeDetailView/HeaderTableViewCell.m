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
    _titleLabel.font = kPingFangMedium(19);
    _titleLabel.textColor = UIColorFromRGB(0x222222);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"标题";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 40);
        make.height.mas_equalTo(27);
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
    }];
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.text = @"小热点";
    _sourceLabel.font = kPingFangRegular(12);
    _sourceLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"2017-09-20";
    _timeLabel.font = kPingFangRegular(12);
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
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
    
    CGFloat titleHeight = [self getHeightByWidth:kMainBoundsWidth - 40 title:model.title font:kPingFangMedium(19)];
    if (titleHeight > 27) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
        }];
    }else{
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(27);
        }];
    }
    self.titleLabel.text = model.title;
    if (isEmptyString(model.sourceName )) {
        _sourceLabel.text = @"";
    }else{
        _sourceLabel.text = [@"选自：" stringByAppendingString:model.sourceName];
    }
    _timeLabel.text = model.bespeak_time;
    
}

@end
