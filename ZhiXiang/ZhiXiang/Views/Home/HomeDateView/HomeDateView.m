//
//  HomeDateView.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeDateView.h"

@interface HomeDateView ()

@property (nonatomic, strong) UILabel * monthLabel;
@property (nonatomic, strong) UILabel * weekLabel;
@property (nonatomic, strong) UILabel * dayLabel;

@end

@implementation HomeDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createSubViews];
        
    }
    return self;
}

- (void)createSubViews
{
    self.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    self.layer.borderWidth = .5f;
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.monthLabel.textColor = UIColorFromRGB(0x4e4e4e);
    self.monthLabel.font = kPingFangRegular(11);
    self.monthLabel.text = @"9月";
    [self addSubview:self.monthLabel];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-3);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.weekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weekLabel.textColor = UIColorFromRGB(0x4e4e4e);
    self.weekLabel.font = kPingFangRegular(11);
    self.weekLabel.text = @"星期四";
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-3);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayLabel.textColor = UIColorFromRGB(0x666666);
    self.dayLabel.font = kPingFangRegular(30);
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.text = @"21";
    [self addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 30));
    }];
}

- (void)configWithModel:(HomeViewModel *)model{
    
    self.monthLabel.text = model.month;
    self.weekLabel.text = model.week;
    self.dayLabel.text = model.day;
}

@end
