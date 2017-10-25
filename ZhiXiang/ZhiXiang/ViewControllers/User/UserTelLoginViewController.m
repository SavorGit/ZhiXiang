//
//  UserTelLoginViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserTelLoginViewController.h"
#import "ZXTools.h"
#import "GetTelCodeRequest.h"
#import "TelLoginRequest.h"
#import "MBProgressHUD+Custom.h"

@interface UserTelLoginViewController ()

@property (nonatomic, strong) UITextField * telTextField;
@property (nonatomic, strong) UITextField * codeTextFiled;
@property (nonatomic, strong) UIButton * sendButton;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) BOOL isChangeTime;

@end

@implementation UserTelLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
}

- (void)createViews
{
    self.title = @"登录";
    self.view.backgroundColor = UIColorFromRGB(0xf8f6f1);
    
    self.telTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.telTextField.backgroundColor = UIColorFromRGB(0xedebe6);
    self.telTextField.layer.cornerRadius = 3.f;
    self.telTextField.layer.masksToBounds = YES;
    self.telTextField.layer.borderColor = UIColorFromRGB(0xe2e0db).CGColor;
    self.telTextField.layer.borderWidth = 1.f;
    self.telTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextField.font = kPingFangRegular(15);
    self.telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.telTextField.placeholder = @"请输入手机号";
    self.telTextField.textColor = UIColorFromRGB(0x333333);
    [self.view addSubview:self.telTextField];
    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ZXTools autoHeightWith:35]);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(38);
    }];
    
    UIView * telLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 18)];
    UIImageView * iPhoneView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 18, 18)];
    [iPhoneView setImage:[UIImage imageNamed:@"Icon_iPhone"]];
    [telLeftView addSubview:iPhoneView];
    self.telTextField.leftView = telLeftView;
    self.telTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.codeTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.codeTextFiled.backgroundColor =UIColorFromRGB(0xedebe6);
    self.codeTextFiled.layer.cornerRadius = 3.f;
    self.codeTextFiled.layer.masksToBounds = YES;
    self.codeTextFiled.layer.borderColor = UIColorFromRGB(0xe2e0db).CGColor;
    self.codeTextFiled.layer.borderWidth = 1.f;
    self.codeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextFiled.font = kPingFangRegular(15);
    self.codeTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextFiled.placeholder = @"请输入验证码";
    self.codeTextFiled.textColor = UIColorFromRGB(0x333333);
    [self.view addSubview:self.codeTextFiled];
    [self.codeTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.telTextField.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(self.telTextField).multipliedBy(420.f/670.f);
        make.height.mas_equalTo(38);
    }];
    
    UIView * codeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 18)];
    UIImageView * lockView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 18, 18)];
    [lockView setImage:[UIImage imageNamed:@"Icon_Lock"]];
    [codeLeftView addSubview:lockView];
    self.codeTextFiled.leftView = codeLeftView;
    self.codeTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.telTextField.mas_bottom).offset(17);
        make.left.mas_equalTo(self.codeTextFiled.mas_right).offset(10);
        make.height.mas_equalTo(34);
        make.right.mas_equalTo(-20);
    }];
    self.sendButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:[ZXTools autoWidthWith:15]];
    self.sendButton.layer.cornerRadius = 3.f;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.borderWidth = 1.f;
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTextFiled.mas_bottom).offset([ZXTools autoHeightWith:80]);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(38);
    }];
    self.loginButton.titleLabel.font = kPingFangRegular(15);
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    self.loginButton.layer.borderWidth = 1.f;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.telTextField canBecomeFirstResponder]) {
        [self.telTextField becomeFirstResponder];
    }
    
    [self sendButtonDisable];
    [self loginButtonDisable];
    [self.telTextField addTarget:self action:@selector(telTextFiledDidChangeValue) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextFiled addTarget:self action:@selector(codeTextFiledDidChangeValue) forControlEvents:UIControlEventEditingChanged];
}

- (void)loginButtonDidClicked
{
    NSString * telNumber =self.telTextField.text;
    if (isEmptyString(telNumber)) {
        [MBProgressHUD showTextHUDWithText:@"手机号码不能为空" inView:self.view];
        return;
    }
    
    NSString * code =self.codeTextFiled.text;
    if (isEmptyString(code)) {
        [MBProgressHUD showTextHUDWithText:@"验证码不能为空" inView:self.view];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assetString = [defaults objectForKey:@"asSetValue"];
    
    TelLoginRequest * request = [[TelLoginRequest alloc] initWithTel:telNumber ptype:assetString code:code openid:[UserManager shareManager].wxOpenID];
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在发送" inView:self.navigationController.view];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showSuccessWithText:@"登录成功" inView:self.navigationController.view];
        [self closeKeyBoard];
        [UserManager shareManager].tel = telNumber;
        [UserManager shareManager].isLoginWithTel = YES;
        [[UserManager shareManager] saveUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZXUserDidLoginSuccessNotification object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * title = [response objectForKey:@"msg"];
        if (!isEmptyString(title)) {
            [MBProgressHUD showTextHUDWithText:title inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [hud hideAnimated:YES];
    }];
    
}

- (void)sendButtonDidClicked
{
    NSString * telNumber =self.telTextField.text;
    if (isEmptyString(telNumber)) {
        [MBProgressHUD showTextHUDWithText:@"手机号码不能为空" inView:self.view];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在发送" inView:self.view];
    GetTelCodeRequest * request = [[GetTelCodeRequest alloc] initWith:telNumber];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"发送成功" inView:self.view];
        [self closeKeyBoard];
        [self createTimeCount];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * title = [response objectForKey:@"msg"];
        if (!isEmptyString(title)) {
            [MBProgressHUD showTextHUDWithText:title inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [hud hideAnimated:YES];
    }];
}

- (void)telTextFiledDidChangeValue
{
    if (self.isChangeTime) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeTime) object:nil];
        self.isChangeTime = NO;
        [self.sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    
    if (self.telTextField.text.length == 0) {
        [self loginButtonDisable];
        [self sendButtonDisable];
    }else{
        
        [self sendButtonEnable];
        if (self.codeTextFiled.text.length != 0) {
            [self loginButtonEnable];
        }
        
        if (self.telTextField.text.length > 20) {
            self.telTextField.text = [self.telTextField.text substringToIndex:20];
        }
    }
}

- (void)codeTextFiledDidChangeValue
{
    if (self.codeTextFiled.text.length == 0) {
        [self loginButtonDisable];
    }else{
        if (self.telTextField.text.length != 0) {
            [self loginButtonEnable];
        }
        
        if (self.codeTextFiled.text.length > 6) {
            self.codeTextFiled.text = [self.codeTextFiled.text substringToIndex:6];
        }
    }
}

- (void)loginButtonDisable
{
    if (self.loginButton.isEnabled) {
        self.loginButton.enabled = NO;
        [self.loginButton setBackgroundColor:UIColorFromRGB(0xcbc9c5)];
        [self.loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
}

- (void)loginButtonEnable
{
    if (!self.loginButton.isEnabled) {
        self.loginButton.enabled = YES;
        [self.loginButton setBackgroundColor:UIColorFromRGB(0x333333)];
        [self.loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
}

- (void)sendButtonDisable
{
    if (self.sendButton.isEnabled) {
        self.sendButton.enabled = NO;
        self.sendButton.layer.borderColor = UIColorFromRGB(0xe3e1dc).CGColor;
        [self.sendButton setTitleColor:UIColorFromRGB(0xb7b6b2) forState:UIControlStateNormal];
    }
}

- (void)sendButtonEnable
{
    if (!self.sendButton.isEnabled) {
        self.sendButton.enabled = YES;
        self.sendButton.layer.borderColor = UIColorFromRGB(0x555555).CGColor;
        [self.sendButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
}

- (void)createTimeCount
{
    if (!self.isChangeTime) {
        self.number = 60;
        [self sendButtonDisable];
        self.isChangeTime = YES;
        [self changeTime];
    }
}

- (void)changeTime
{
    if (self.number == 0) {
        [self.sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        if (self.telTextField.text.length != 0) {
            [self sendButtonEnable];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeTime) object:nil];
        self.isChangeTime = NO;
        return;
    }
    
    NSString * str = [NSString stringWithFormat:@"%lds后重新发送", self.number];
    [self.sendButton setTitle:str forState:UIControlStateNormal];
    self.number--;
    [self performSelector:@selector(changeTime) withObject:nil afterDelay:1.f];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self closeKeyBoard];
}

- (void)closeKeyBoard
{
    if (self.telTextField.isFirstResponder) {
        [self.telTextField resignFirstResponder];
    }else if (self.codeTextFiled.isFirstResponder) {
        [self.codeTextFiled resignFirstResponder];
    }
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
