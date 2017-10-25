//
//  UserLoginWayViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserLoginWayViewController.h"
#import "ZXTools.h"
#import "MBProgressHUD+Custom.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UserTelLoginViewController.h"

@interface UserLoginWayViewController ()

@end

@implementation UserLoginWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
}

- (void)createViews
{
    self.title = @"登录";
    self.view.backgroundColor = UIColorFromRGB(0xf8f6f1);
    
    UIView * wxView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:wxView];
    [wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo([ZXTools autoHeightWith:150.f]);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    UITapGestureRecognizer * axTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxLogin)];
    axTap.numberOfTapsRequired = 1;
    [wxView addGestureRecognizer:axTap];
    [wxView setExclusiveTouch:YES];
    
    UIImageView * wxLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [wxLogo setImage:[UIImage imageNamed:@"weixindenglu"]];
    [wxView addSubview:wxLogo];
    [wxLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
    }];
    
    UILabel * wxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    wxLabel.textAlignment = NSTextAlignmentCenter;
    wxLabel.textColor =UIColorFromRGB(0x333333);
    wxLabel.font = kPingFangRegular(15);
    wxLabel.text = @"微信登录";
    [wxView addSubview:wxLabel];
    [wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wxLogo.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    UILabel * otherWayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    otherWayLabel.textColor = UIColorFromRGB(0x808080);
    otherWayLabel.font = kPingFangRegular(14);
    otherWayLabel.textAlignment = NSTextAlignmentCenter;
    otherWayLabel.text = @"其它方式";
    [self.view addSubview:otherWayLabel];
    [otherWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-[ZXTools autoHeightWith:102]);
        make.height.mas_equalTo(14);
    }];
    
    UIView * leftLineView = [[UIView alloc] initWithFrame:CGRectZero];
    leftLineView.backgroundColor = UIColorFromRGB(0xcccbc8);
    [self.view addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(-[ZXTools autoHeightWith:109]);
        make.height.mas_equalTo(.5f);
        make.right.mas_equalTo(otherWayLabel.mas_left).offset(-10);
    }];
    
    UIView * rightLineView = [[UIView alloc] initWithFrame:CGRectZero];
    rightLineView.backgroundColor = UIColorFromRGB(0xcccbc8);
    [self.view addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(-[ZXTools autoHeightWith:109]);
        make.height.mas_equalTo(.5f);
        make.left.mas_equalTo(otherWayLabel.mas_right).offset(10);
    }];
    
    UIView * telView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:telView];
    [telView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(otherWayLabel.mas_bottom).offset([ZXTools autoHeightWith:25]);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(120);
        make.centerX.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telLogin)];
    tap.numberOfTapsRequired = 1;
    [telView addGestureRecognizer:tap];
    [telView setExclusiveTouch:YES];
    
    UIImageView * telLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [telLogo setImage:[UIImage imageNamed:@"shoujidenglu"]];
    [telView addSubview:telLogo];
    [telLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 18));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(12);
    }];
    
    UILabel * telLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    telLabel.textColor = UIColorFromRGB(0x333333);
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.font = kPingFangRegular(15);
    telLabel.text = @"手机号登录";
    [telView addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(telLogo.mas_right).offset(6);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView * telLineView = [[UIView alloc] initWithFrame:CGRectZero];
    telLineView.backgroundColor = UIColorFromRGB(0x333333);
    [telLabel addSubview:telLineView];
    [telLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)telLogin
{
    UserTelLoginViewController * tel = [[UserTelLoginViewController alloc] init];
    [self.navigationController pushViewController:tel animated:YES];
}

- (void)wxLogin
{
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            
            if (nil == error && [result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                
                [MBProgressHUD showTextHUDWithText:@"授权成功" inView:self.navigationController.view];
                [[UserManager shareManager] configWithUMengResponse:result];
                [[UserManager shareManager] saveUserInfo];
                [ZXTools weixinLoginUpdate];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZXUserDidLoginSuccessNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showTextHUDWithText:@"授权失败" inView:self.view];
            }
        }];
    }else{
        [MBProgressHUD showTextHUDWithText:@"请安装微信后使用" inView:self.view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
