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

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat tHeight;

@end

@implementation SpecialHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _imageHeight =  kMainBoundsHeight - kStatusBarHeight - kNaviBarHeight - 30 - 70;
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.frame = CGRectMake(0, 0, kMainBoundsWidth, _imageHeight/2);
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
    _titleLabel.frame = CGRectMake(15, _imageHeight/2 + 20, kMainBoundsWidth - 30, 31);
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
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _imageHeight/2 + 20 + 31, kMainBoundsWidth - 30, 20)];
    _subTitleLabel.text = @"";
    _subTitleLabel.font = kPingFangLight(15);
    _subTitleLabel.textColor = UIColorFromRGB(0x575757);
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    _subTitleLabel.numberOfLines = 0;
    [self addSubview:_subTitleLabel];
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
    
    CGFloat titleHeight = [self getHeightByWidth:kMainBoundsWidth - 30 title:model.title font:kPingFangMedium(22)];
    _tHeight = [self getHeightByWidth:kMainBoundsWidth - 30 - 60 title:model.title font:kPingFangMedium(22)];
    CGFloat maxHeight = 31;
    if (titleHeight > 31) {
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
    _titleLabel.frame = CGRectMake(15, _imageHeight/2 + 20, kMainBoundsWidth - 30, maxHeight);
    self.titleLabel.text = model.title;
    
    self.subTitleLabel.text = model.desc;
//    [self configDescLabel];
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
    self.descHeight = descHeight;
    self.subTitleLabel.frame = CGRectMake(15, _imageHeight/2 + 20 + maxHeight + 20, kMainBoundsWidth - 30, descHeight);
    
    
    if ([self.imageURL isEqualToString:model.imageURL]) {
        return;
    }
    self.imageURL = model.img_url;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
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
    self.descHeight = descHeight;
    self.subTitleLabel.frame = CGRectMake(15, _imageHeight/2 + 20 + 31, kMainBoundsWidth - 30, 20);
    
//    [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, descHeight));
//    }];
}
- (void)endScrShow{
    
    
    _bgImageView.frame = CGRectMake(0, 0, kMainBoundsWidth - 60, _imageHeight/2);
    
    _titleLabel.frame = CGRectMake(15, _imageHeight/2 + 20, kMainBoundsWidth - 30 - 60, _tHeight);
    
    _subTitleLabel.frame = CGRectMake(15, _imageHeight/2 + 20 + _tHeight + 20, kMainBoundsWidth - 30 - 60, _descHeight);
}

@end
