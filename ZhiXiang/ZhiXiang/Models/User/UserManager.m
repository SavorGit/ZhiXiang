//
//  UserManager.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserManager.h"

NSString * const ZXUserDidLoginSuccessNotification = @"ZXUserDidLoginSuccessNotification";

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
                     @"isLoginWithTel":@(self.isLoginWithTel)
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
                     @"isLoginWithWX" : @(self.isLoginWithWX)
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

@end
