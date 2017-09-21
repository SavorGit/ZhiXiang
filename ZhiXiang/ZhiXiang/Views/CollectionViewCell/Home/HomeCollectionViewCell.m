//
//  HomeCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HomeCollectionViewCell ()

@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * bottoView;
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UILabel *subTitleLabel;

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
    self.topView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.backgroundColor = [UIColor clearColor];
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
    self.bottoView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 60 - 30, 0)];
    self.subTitleLabel.text = @"";
    self.subTitleLabel.font = kPingFangLight(15);
    self.subTitleLabel.textColor = UIColorFromRGB(0x575757);
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.numberOfLines = 0;
    [self.bottoView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60 - 30, 20));
        make.top.equalTo(self.topView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
}

- (void)configModelData:(HomeViewModel *)model{
    
    self.subTitleLabel.text = model.desc;
    [self configDescLabel];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
//    self.subTitleLabel.text = @"“艾尔玛”给佛罗里达州带来巨大损失。电视画面显示，佛罗里达半岛西部城市那不勒斯、坦帕附近海面掀起的巨浪最高达到5米。迈阿密的很多大树被连根拔起，一些房屋墙壁中的保温材料被风吹落，堆积在街道。而迈阿密国际机场因积水漫灌，已严重损毁。";
//    [self configDescLabel];
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://devp.oss.littlehotspot.com/media/resource/7GbaE4cxsF.jpg"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
}

- (void)configDescLabel{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.subTitleLabel.text];
    NSUInteger length = [self.subTitleLabel.text length];
    [attrString addAttribute:NSFontAttributeName value:kPingFangLight(15) range:NSMakeRange(0, length)];//设置所有的字体
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    self.subTitleLabel.attributedText = attrString;
    
    // 计算富文本的高度
    CGFloat descHeight = [self.subTitleLabel sizeThatFits:self.subTitleLabel.bounds.size].height;
    [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60 - 30, descHeight));
    }];
}

@end
