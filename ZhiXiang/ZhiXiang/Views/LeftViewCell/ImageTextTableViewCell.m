//
//  ImageTextTableViewCell.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/7/3.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "ImageTextTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Additional.h"

@interface ImageTextTableViewCell ()

@property (nonatomic, copy) NSString * imageURL;

@end

@implementation ImageTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.equalTo(_bgImageView.mas_width).multipliedBy(802.f/1242.f);//84
        make.top.mas_equalTo(7.5);
        make.left.mas_equalTo(15);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangMedium(16);
    _titleLabel.textColor = UIColorFromRGB(0x222222);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"标题";
    self.titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 140 - 38);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(_bgImageView.mas_top).offset(5);
        make.left.mas_equalTo(_bgImageView.mas_right).offset(15);
    }];
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.text = @"";
    _sourceLabel.font = kPingFangRegular(12);
    _sourceLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-5);
        make.left.mas_equalTo(_bgImageView.mas_right).offset(15);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = kPingFangRegular(12);
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-5);
        make.left.equalTo(_sourceLabel.mas_right).offset(15);
    }];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = UIColorFromRGB(0xe4e2de);
    [self addSubview:_lineView];
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 15, 1));
        make.bottom.mas_equalTo(self.bottom).offset(-1);
        make.left.mas_equalTo(15);
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

- (void)configModelData:(MyCollectionModel *)model{
    
    CGFloat titleHeight = [self getHeightByWidth:(kMainBoundsWidth - 140 - 38) title:model.title font:kPingFangMedium(16)];
    if (titleHeight > 30) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
    }else{
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    }
    self.titleLabel.text = model.title;
    
    self.sourceLabel.text = model.sourceName;
    self.timeLabel.text = model.bespeak_time;
    if ([self.imageURL isEqualToString:model.imgUrl]) {
        return;
    }
    self.imageURL = model.imgUrl;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            if ([manager diskImageExistsForURL:[NSURL URLWithString:model.imgUrl]]) {
                NSLog(@"不加载动画");
            }else {
                
                self.bgImageView.alpha = 0.0;
                [UIView transitionWithView:self.bgImageView
                                  duration:1.0f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    [self.bgImageView setImage:image];
                                    self.bgImageView.alpha = 1.0;
                                } completion:NULL];
            }
        }
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
