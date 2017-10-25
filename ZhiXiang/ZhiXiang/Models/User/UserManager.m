//
//  UserManager.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserManager.h"
#import <AFNetworking.h>

NSString * const ZXUserDidLoginSuccessNotification = @"ZXUserDidLoginSuccessNotification";

@interface UserManager ()

@property (nonatomic, strong) NSURLSessionDataTask * updateTask;

@end

@implementation UserManager

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static UserManager * instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)configWithDictionary:(NSDictionary *)userInfo
{
    BOOL isWX = [[userInfo objectForKey:@"isLoginWithWX"] boolValue];
    self.isLoginWithWX = isWX;
    if (isWX) {
        self.wxUserName = [userInfo objectForKey:@"wxUserName"];
        self.wxIcon = [userInfo objectForKey:@"wxIcon"];
        self.wxUID = [userInfo objectForKey:@"wxUID"];
        self.wxOpenID = [userInfo objectForKey:@"wxOpenID"];
        self.wxUnionID = [userInfo objectForKey:@"wxUnionID"];
        self.unionGender = [userInfo objectForKey:@"unionGender"];
        self.gender = [userInfo objectForKey:@"gender"];
        self.wxOriginalResponse = [userInfo objectForKey:@"wxOriginalResponse"];
        self.access_token = [userInfo objectForKey:@"access_token"];
        self.refresh_token = [userInfo objectForKey:@"refresh_token"];
    }
    
    BOOL isTel = [[userInfo objectForKey:@"isLoginWithTel"] boolValue];
    self.isLoginWithTel = isTel;
    if (isTel) {
        self.tel = [userInfo objectForKey:@"tel"];
    }
}

- (void)configWithUMengResponse:(UMSocialUserInfoResponse *)response
{
    self.wxUserName = response.name;
    self.wxIcon = response.iconurl;
    self.wxUID = response.uid;
    self.wxOpenID = response.openid;
    self.wxUnionID = response.unionId;
    self.unionGender = response.unionGender;
    self.gender = response.gender;
    self.wxOriginalResponse = response.originalResponse;
    self.access_token = response.accessToken;
    self.refresh_token = response.refreshToken;
    
    self.isLoginWithWX = YES;
}

- (BOOL)saveUserInfo
{
    NSDictionary * userInfo;
    if (self.isLoginWithWX && self.isLoginWithTel) {
        userInfo = @{@"wxUserName" : self.wxUserName,
                     @"wxIcon"     : self.wxIcon,
                     @"wxUID"      : self.wxUID,
                     @"wxOpenID"   : self.wxOpenID,
                     @"wxUnionID"  : self.wxUnionID,
                     @"unionGender": self.unionGender,
                     @"gender"     : self.gender,
                     @"tel"        : self.tel,
                     @"wxOriginalResponse" : self.wxOriginalResponse,
                     @"isLoginWithWX" : @(self.isLoginWithWX),
                     @"isLoginWithTel": @(self.isLoginWithTel),
                     @"access_token"   : self.access_token,
                     @"refresh_token"  : self.refresh_token
                     };
    }else if (self.isLoginWithWX){
        userInfo = @{@"wxUserName" : self.wxUserName,
                     @"wxIcon"     : self.wxIcon,
                     @"wxUID"      : self.wxUID,
                     @"wxOpenID"   : self.wxOpenID,
                     @"wxUnionID"  : self.wxUnionID,
                     @"unionGender": self.unionGender,
                     @"gender"     : self.gender,
                     @"wxOriginalResponse" : self.wxOriginalResponse,
                     @"isLoginWithWX" : @(self.isLoginWithWX),
                     @"access_token"   : self.access_token,
                     @"refresh_token"  : self.refresh_token
                     };
    }else if (self.isLoginWithTel){
        userInfo = @{
                     @"tel"            : self.tel,
                     @"isLoginWithTel" : @(self.isLoginWithTel)
                     };
    }else{
        return NO;
    }
    
    return [userInfo writeToFile:UserInfoPath atomically:YES];
}

- (void)canleLogin
{
    self.isLoginWithWX = NO;
    self.isLoginWithTel = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:UserInfoPath error:nil];
    }
}

- (void)updateUserAccessToken
{
    NSString * refreshToken = self.refresh_token;
    if (!isEmptyString(refreshToken)) {
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",nil];
        manager.requestSerializer.timeoutInterval = 15.f;
        NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wxa5ea2522d1a6785e&grant_type=refresh_token&refresh_token=%@", refreshToken];
        self.updateTask = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject objectForKey:@"refresh_token"]) {
                NSString * refreshToken = [responseObject objectForKey:@"refresh_token"];
                if (!isEmptyString(refreshToken)) {
                    self.refresh_token = refreshToken;
                    self.access_token = [responseObject objectForKey:@"access_token"];
                    self.wxOpenID = [responseObject objectForKey:@"openid"];
                    [self saveUserInfo];
                    return;
                }
            }
            [[UserManager shareManager] canleLogin];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        [self canleLogin];
    }
}

@end
