//
//  HomeCommandCollectionViewCell.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeCommandCollectionViewCell.h"
#import "UMCustomSocialManager.h"
#import "MBProgressHUD+Custom.h"
#import "ZXTools.h"

@interface HomeCommandCollectionViewCell ()

@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation HomeCommandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createViews];
        
    }
    return self;
}

- (void)createViews
{
    self.contentView.backgroundColor = UIColorFromRGB(0xf8f6f1);
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgImageView setImage:[UIImage imageNamed:@"tuijian"]];
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.backgroundColor = UIColorFromRGB(0xf8f6f1);
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.bgImageView.mas_width).multipliedBy(488.f/750.f);
    }];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = @"每日知享，高端人士的内容管家";
    self.titleLabel.textColor = UIColorFromRGB(0x222222);
    if (isiPhone_Plus) {
        self.titleLabel.font = kPingFangMedium(21);
    }else{
        self.titleLabel.font = kPingFangMedium(19);
    }
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(22);
    }];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 30, self.bounds.size.height - self.bounds.size.width * 488.f/750.f)];
    
    self.subTitleLabel.text = @"它摈弃所有无意义的内容，\n每天精编全网最有价值的10条，\n最高效的满足您对价值和品味的需求。";
    if (isiPhone_Plus) {
        self.subTitleLabel.font = kPingFangRegular(18);
    }else{
        self.subTitleLabel.font = kPingFangRegular(15);
    }
    self.subTitleLabel.textColor = UIColorFromRGB(0x575757);
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.subTitleLabel.bounds.size);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
    [self configDescLabel];
    
    [self createShareView];
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
    style.paragraphSpacing = 0;//段落后面的间距
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
            subTitleHeight = bottomHeight - 25 - 15 - 60 - 100;
        }else{
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 22 - 100;
        }
    }else{
        titleHeight = [ZXTools getHeightByWidth:self.bounds.size.width - 30 title:self.titleLabel.text font:kPingFangMedium(19)];
        
        if (titleHeight > 32) {
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(54);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 54 - 100;
        }else{
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
            }];
            subTitleHeight = bottomHeight - 25 - 15 - 20 - 100;
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

- (void)createShareView
{
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        return;
    }
    
    UIView * shareView = [[UIView alloc] initWithFrame:CGRectZero];
    
    BOOL is4S = isiPhone4S;
    
    if (is4S) {
        UIView * blackView = [[UIView alloc] initWithFrame:CGRectZero];
        blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        [self.bgImageView addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    
    UIColor * mainColor;
    UIColor * buttonColor;
    if (is4S) {
        mainColor = [UIColor whiteColor];
        buttonColor = [UIColor whiteColor];
    }else{
        mainColor = UIColorFromRGB(0x444444);
        buttonColor = UIColorFromRGB(0x222222);
    }
    
    [self.contentView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(108);
        
        if (isiPhone4S) {
            make.centerY.mas_equalTo(self.bgImageView);
        }else{
            make.bottom.mas_equalTo(0);
        }
        
    }];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = mainColor;
    label.font = kPingFangRegular(14);
    label.text = @"推荐APP给好友";
    [shareView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    
    UIView * leftLine = [[UIView alloc] initWithFrame:CGRectZero];
    leftLine.backgroundColor = mainColor;
    [shareView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(label.mas_left).offset(-6);
        make.height.mas_equalTo(.5f);
    }];
    
    UIView * rightLine = [[UIView alloc] initWithFrame:CGRectZero];
    rightLine.backgroundColor = mainColor;
    [shareView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(label.mas_right).offset(6);
        make.height.mas_equalTo(.5f);
    }];
    
    NSString * weixin = @"weixin";
    NSString * pyq = @"pyq";
    
    if (!is4S) {
        weixin = [weixin stringByAppendingString:@"_black"];
        pyq = [pyq stringByAppendingString:@"_black"];
    }
    
    CGFloat distance = (self.frame.size.width - 80) / 3;
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:weixin] forState:UIControlStateNormal];
    [leftButton setTitle:@"微信" forState:UIControlStateNormal];
    leftButton.titleLabel.font = kPingFangRegular(11);
    [leftButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [shareView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(60);
        make.left.mas_equalTo(distance);
        make.top.mas_equalTo(label.mas_bottom).offset(20);
    }];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 20, 0)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(32, -34, 0, 0)];
    leftButton.tag = 100;
    [leftButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:pyq] forState:UIControlStateNormal];
    [rightButton setTitle:@"朋友圈" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kPingFangRegular(11);
    [rightButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [shareView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(-distance);
        make.top.mas_equalTo(label.mas_bottom).offset(20);
    }];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 20, 0)];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(32, -32, 0, 0)];
    [rightButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareAction:(UIButton *)button
{
    if ([UserManager shareManager].isLoginWithWX) {
        if (button.tag == 100) {
            [[UMCustomSocialManager defaultManager] sharedAPPToPlatform:UMSocialPlatformType_WechatSession andController:self.VC andView:self.VC.view andUmKeyString:@""];
        }else{
            [[UMCustomSocialManager defaultManager] sharedAPPToPlatform:UMSocialPlatformType_WechatTimeLine andController:self.VC andView:self.VC.view andUmKeyString:@""];
        }
    }else{
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self.VC completion:^(id result, NSError *error) {
            
            if (nil == error && [result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                
                [MBProgressHUD showTextHUDWithText:@"授权成功" inView:self.VC.view];
                [[UserManager shareManager] configWithUMengResponse:result];
                [[UserManager shareManager] saveUserInfo];
                [ZXTools weixinLoginUpdate];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZXUserDidLoginSuccessNotification object:nil];
                [(UINavigationController *)self.VC popToRootViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showTextHUDWithText:@"授权失败" inView:self.VC.view];
            }
        }];
    }
}

@end
