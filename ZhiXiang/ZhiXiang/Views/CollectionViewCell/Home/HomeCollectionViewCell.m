//
//  HomeCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZXTools.h"

@interface HomeCollectionViewCell ()

@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * bottoView;
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel * fromLabel;
@property (nonatomic, strong) UILabel * titleLabel;

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
        make.height.equalTo(self.topView.mas_width).multipliedBy(488.f/750.f);
    }];
    self.topView.backgroundColor = UIColorFromRGB(0xf8f6f1);
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.backgroundColor = UIColorFromRGB(0xf8f6f1);
    [_topView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.bottoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.baseView addSubview:self.bottoView];
    [self.bottoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
    }];
    self.bottoView.backgroundColor = UIColorFromRGB(0xf8f6f1);
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = @"";
    self.titleLabel.textColor = UIColorFromRGB(0x222222);
    if (isiPhone_Plus) {
        self.titleLabel.font = kPingFangMedium(21);
    }else{
        self.titleLabel.font = kPingFangMedium(19);
    }
    self.titleLabel.numberOfLines = 2;
    [self.bottoView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(22);
    }];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 30, self.bounds.size.height - self.bounds.size.width * 488.f/750.f)];
    self.subTitleLabel.text = @"";
    if (isiPhone_Plus) {
        self.subTitleLabel.font = kPingFangRegular(18);
    }else{
        self.subTitleLabel.font = kPingFangRegular(15);
    }
    self.subTitleLabel.textColor = UIColorFromRGB(0x575757);
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.numberOfLines = 0;
    [self.bottoView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.subTitleLabel.bounds.size);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
    self.fromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fromLabel.text = @"";
    self.fromLabel.textAlignment = NSTextAlignmentRight;
    self.fromLabel.textColor = UIColorFromRGB(0xcd313e);
    self.fromLabel.font = kPingFangRegular(16);
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-13);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
    }];
}

- (void)configModelData:(HomeViewModel *)model{
    
    if (isEmptyString(model.artpro)) {
        self.fromLabel.text = @"";
    }else{
        self.fromLabel.text = [NSString stringWithFormat:@"[ %@ ]", model.artpro];
    }
    
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.desc;
    [self configDescLabel];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
}

- (void)configDescLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.subTitleLabel.text];
    NSUInteger length = [self.subTitleLabel.text length];
    if (isiPhone_Plus) {
        [attrString addAttribute:NSFontAttributeName value:kPingFangRegular(18) range:NSMakeRange(0, length)];//设置所有的字体
    }else{
        [attrString addAttribute:NSFontAttributeName value:kPingFangRegular(15) range:NSMakeRange(0, length)];//设置所有的字体
    }
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@1 range:NSMakeRange(0, length)];//字符间距 2pt
    self.subTitleLabel.attributedText = attrString;

    // 计算富文本的高度
    CGFloat descHeight = [self.subTitleLabel sizeThatFits:self.subTitleLabel.bounds.size].height;

    CGFloat bottomHeight = self.bounds.size.height - self.bounds.size.width * (488.f / 750.f);

    CGFloat titleHeight;
    CGFloat subTitleHeight;
    if (isiPhone_Plus) {
        titleHeight = [ZXTools getHeightByWidth:self.bounds.size.width - 30 title:self.titleLabel.text font:kPingFangMedium(21)];
        if (titleHeight > 32) {
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(60);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 60 - 15 - 15 - 10;
        }else{
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 22 - 15 - 15 - 10;
        }
    }else{
        titleHeight = [ZXTools getHeightByWidth:self.bounds.size.width - 30 title:self.titleLabel.text font:kPingFangMedium(19)];
        
        if (titleHeight > 32) {
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(54);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 54 - 15 - 15 - 10;
        }else{
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 20 - 15 - 15 - 10;
        }
    }

    if (subTitleHeight < 15.f) {
        subTitleHeight = 15.f;
    }
    
    if (descHeight >= subTitleHeight) {
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 30, subTitleHeight));
        }];
    }else{
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 30, descHeight + 10.f));
        }];
    }
}

@end
