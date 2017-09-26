//
//  ShareBoardView.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/25.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ShareBoardView.h"
#import "Helper.h"
#import "UIView+Additional.h"

@interface ShareBoardView()

@property(nonatomic ,strong) HomeViewModel *model;
@property(nonatomic ,weak) UIViewController *VC;
@property(nonatomic ,strong) UIImageView *bgView;

@end

@implementation ShareBoardView


- (instancetype)initWithFrame:(CGRect)frame Model:(HomeViewModel *)model andVC:(UIViewController *)VC{
   self = [super initWithFrame:frame];
    if (self) {
        
        self.model = model;
        self.VC = VC;
        
        self.tag = 1888;
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.bottom = keyWindow.top;
        [keyWindow addSubview:self];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guidPress)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        UIToolbar *toolBarView = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolBarView.barStyle = UIBarStyleBlackTranslucent;
        [self addSubview:toolBarView];
        
        [self showViewWithAnimationDuration:.3f];
        
        [self creatSubViews];
    }
    return self;
}

- (void)guidPress{
    
    [self dismissViewWithAnimationDuration:.3f];
    
}

#pragma mark - show view
-(void)showViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.bottom = keyWindow.bottom;
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.bottom = keyWindow.top;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)creatSubViews{
    
    self.bgView = [[UIImageView alloc] init];
    float bgVideoHeight = [Helper autoHeightWith:120];
    self.bgView.frame = CGRectZero;
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.userInteractionEnabled = YES;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,bgVideoHeight));
        make.center.mas_equalTo(self);
    }];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(60, 14.5, ([UIScreen mainScreen].bounds.size.width - 60 )/2 - 60, 1)];
    leftLine.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [self.bgView addSubview:leftLine];
    
    UILabel *shareTLab = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60)/2, 0, 60, 30)];
    shareTLab.text = @"分享到";
    shareTLab.font = kPingFangRegular(14);
    shareTLab.textColor = UIColorFromRGB(0xbbbbbb);
    shareTLab.backgroundColor = [UIColor clearColor];
    shareTLab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:shareTLab];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60)/2 + 60, 14.5, ([UIScreen mainScreen].bounds.size.width - 60)/2 - 60, 1)];
    rightLine.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [self.bgView addSubview:rightLine];
    
    [self creatContentViews];
}

- (void)creatContentViews{
    UIButton *shareWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareWXBtn.backgroundColor = [UIColor clearColor];
    [shareWXBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [shareWXBtn addTarget:self action:@selector(shareWxBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:shareWXBtn];
    [shareWXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self.centerX).offset(- (19 + 45));
    }];
    
    UILabel *shareWLab = [[UILabel alloc] initWithFrame:CGRectZero];
    shareWLab.text = @"微信";
    shareWLab.font = kPingFangRegular(13);
    shareWLab.textColor = UIColorFromRGB(0xffffff);
    shareWLab.backgroundColor = [UIColor clearColor];
    shareWLab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:shareWLab];
    [shareWLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.top.mas_equalTo(shareWXBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(shareWXBtn.mas_left);
    }];
    
    
    UIButton *shareFRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareFRBtn.backgroundColor = [UIColor clearColor];
    [shareFRBtn setImage:[UIImage imageNamed:@"pyq"] forState:UIControlStateNormal];
    [shareFRBtn addTarget:self action:@selector(shareFRBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:shareFRBtn];
    [shareFRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self.centerX).offset(19 + 45);
    }];
    
    UILabel *shareFLab = [[UILabel alloc] initWithFrame:CGRectZero];
    shareFLab.text = @"朋友圈";
    shareFLab.font = kPingFangRegular(13);
    shareFLab.textColor = UIColorFromRGB(0xffffff);
    shareFLab.backgroundColor = [UIColor clearColor];
    shareFLab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:shareFLab];
    [shareFLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.top.mas_equalTo(shareWXBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(shareFRBtn.mas_left).offset(0);
    }];
}

- (void)shareWxBtn{
    
    [[UMCustomSocialManager defaultManager] sharedToPlatform:UMSocialPlatformType_WechatSession andController:self.VC andView:self withModel:self.model andUmKeyString:@"shortcut_share_weixin"];
}

- (void)shareFRBtn{
    
    [[UMCustomSocialManager defaultManager] sharedToPlatform:UMSocialPlatformType_WechatTimeLine andController:self.VC
    andView:self  withModel:self.model andUmKeyString:@"shortcut_share_weixin_friends"];
    
}

@end
