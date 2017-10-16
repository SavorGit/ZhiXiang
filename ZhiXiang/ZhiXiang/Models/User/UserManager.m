//
//  UserManager.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserManager.h"

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
    self.wxUserName = [userInfo objectForKey:@"wxUserName"];
    self.wxIcon = [userInfo objectForKey:@"wxIcon"];
    self.wxUID = [userInfo objectForKey:@"wxUID"];
    self.wxOpenID = [userInfo objectForKey:@"wxOpenID"];
    self.wxUnionID = [userInfo objectForKey:@"wxUnionID"];
    self.unionGender = [userInfo objectForKey:@"unionGender"];
    self.gender = [userInfo objectForKey:@"gender"];
    self.wxOriginalResponse = [userInfo objectForKey:@"wxOriginalResponse"];
    
    self.isLogin = YES;
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
    
    self.isLogin = YES;
}

- (BOOL)saveUserInfo
{
    NSDictionary * userInfo = @{@"wxUserName" : self.wxUserName,
                                @"wxIcon"     : self.wxIcon,
                                @"wxUID"      : self.wxUID,
                                @"wxOpenID"   : self.wxOpenID,
                                @"wxUnionID"  : self.wxUnionID,
                                @"unionGender": self.unionGender,
                                @"gender"     : self.gender,
                                @"wxOriginalResponse" : self.wxOriginalResponse
                                };
    
    return [userInfo writeToFile:UserInfoPath atomically:YES];
}

- (void)canleLogin
{
    self.isLogin = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:UserInfoPath error:nil];
    }
}

@end
