//
//  LeftCacheCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/16.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LeftCacheCell.h"

@interface LeftCacheCell()

@property (nonatomic, strong) UILabel * cacheLabel;

@end

@implementation LeftCacheCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.cacheLabel = [[UILabel alloc] init];
        self.cacheLabel.backgroundColor = [UIColor clearColor];
        self.cacheLabel.font = kPingFangLight(13);
        self.cacheLabel.textColor = UIColorFromRGB(0x808080);
        self.cacheLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.cacheLabel];
        [self.cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setCacheSize:(NSString *)cacheSize
{
    self.cacheLabel.text = cacheSize;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.cacheLabel.textColor = UIColorFromRGB(0xffffff);
    }else{
        self.cacheLabel.textColor = UIColorFromRGB(0x808080);
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.cacheLabel.textColor = UIColorFromRGB(0xffffff);
//    }else{
//        self.cacheLabel.textColor = UIColorFromRGB(0x808080);
//    }
//}

@end
