//
//  LeftTableViewCell.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell()

@property (nonatomic, strong) UIImageView * leftImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LeftTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImageView.layer.masksToBounds = YES;
    _leftImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(1);
        make.left.mas_equalTo(30);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = kPingFangLight(16);
    _titleLabel.textColor = UIColorFromRGB(0xF0F0F0);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"标题";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(_leftImageView.mas_right).offset(10);
        make.top.mas_equalTo(0);
    }];
    
}
- (void)configTitle:(NSString *)title andImage:(NSString *)imageStr{
    
    _leftImageView.image = [UIImage imageNamed:imageStr];
    _titleLabel.text = title;
}

@end
