//
//  LeftTableViewCell.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell()

@property (nonatomic, copy) NSString * imageName;

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
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(30);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = kPingFangLight(15);
    _titleLabel.textColor = UIColorFromRGB(0x808080);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"标题";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(_leftImageView.mas_right).offset(35);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0x303030);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(25);
        make.height.mas_equalTo(.5f);
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)configTitle:(NSString *)title andImage:(NSString *)imageStr{
    
    self.imageName = imageStr;
    _leftImageView.image = [UIImage imageNamed:self.imageName];
    _titleLabel.text = title;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _leftImageView.image = [UIImage imageNamed:[self.imageName stringByAppendingString:@"_dj"]];
    }else{
        _titleLabel.textColor = UIColorFromRGB(0x808080);
        _leftImageView.image = [UIImage imageNamed:self.imageName];
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        _titleLabel.textColor = UIColorFromRGB(0xffffff);
//        _leftImageView.image = [UIImage imageNamed:[self.imageName stringByAppendingString:@"_dj"]];
//    }else{
//        _titleLabel.textColor = UIColorFromRGB(0x808080);
//        _leftImageView.image = [UIImage imageNamed:self.imageName];
//    }
//}

@end
