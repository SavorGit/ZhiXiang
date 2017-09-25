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
@property(nonatomic ,strong) MyCollectionModel *model;

@end
@implementation ShareBoardView


- (instancetype)initWithFrame:(CGRect)frame Model:(MyCollectionModel *)model{
   self = [super initWithFrame:frame];
    if (self) {
        
        self.model = model;
        
        self.tag = 1888;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.bottom = keyWindow.top;
        [keyWindow addSubview:self];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guidPress)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
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
    
    UIImageView *bgView = [[UIImageView alloc] init];
    float bgVideoHeight = [Helper autoHeightWith:120];
    bgView.frame = CGRectZero;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,bgVideoHeight));
        make.center.mas_equalTo(self);
    }];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(40, 14.5, ([UIScreen mainScreen].bounds.size.width - 60 )/2 - 40, 1)];
    leftLine.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [bgView addSubview:leftLine];
    
    UILabel *shareTLab = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60)/2, 0, 60, 30)];
    shareTLab.text = @"分享到";
    shareTLab.font = kPingFangRegular(14);
    shareTLab.textColor = UIColorFromRGB(0xbbbbbb);
    shareTLab.backgroundColor = [UIColor clearColor];
    shareTLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:shareTLab];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60)/2 + 60, 14.5, ([UIScreen mainScreen].bounds.size.width - 60)/2 - 40, 1)];
    rightLine.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [bgView addSubview:rightLine];
    
    UIButton *shareWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareWXBtn.backgroundColor = [UIColor cyanColor];
    [shareWXBtn addTarget:self action:@selector(shareWxBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareWXBtn];
    [shareWXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.top.mas_equalTo(shareTLab.mas_bottom).offset(10);
        make.left.mas_equalTo(100);
    }];
    
    UILabel *shareWLab = [[UILabel alloc] initWithFrame:CGRectZero];
    shareWLab.text = @"微信";
    shareWLab.font = kPingFangRegular(13);
    shareWLab.textColor = UIColorFromRGB(0xffffff);
    shareWLab.backgroundColor = [UIColor clearColor];
    shareWLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:shareWLab];
    [shareWLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.top.mas_equalTo(shareWXBtn.mas_bottom).offset(0);
        make.left.mas_equalTo(100);
    }];
    
    
    UIButton *shareFRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareFRBtn.backgroundColor = [UIColor redColor];
    [shareFRBtn addTarget:self action:@selector(shareFRBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareFRBtn];
    [shareFRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.top.mas_equalTo(shareTLab.mas_bottom).offset(10);
        make.left.mas_equalTo(shareWXBtn.mas_right).offset(100);
    }];
    
    UILabel *shareFLab = [[UILabel alloc] initWithFrame:CGRectZero];
    shareFLab.text = @"朋友圈";
    shareFLab.font = kPingFangRegular(13);
    shareFLab.textColor = UIColorFromRGB(0xffffff);
    shareFLab.backgroundColor = [UIColor clearColor];
    shareFLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:shareFLab];
    [shareFLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.top.mas_equalTo(shareWXBtn.mas_bottom).offset(0);
        make.left.mas_equalTo(shareFRBtn.mas_left).offset(0);
    }];

    
}

- (void)shareWxBtn{
    
}

- (void)shareFRBtn{
    
}

@end
