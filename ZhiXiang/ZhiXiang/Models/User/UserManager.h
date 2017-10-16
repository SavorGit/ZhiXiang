//
//  UserManager.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialResponse.h>

@interface UserManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString * wxUserName; //微信用户名称
@property (nonatomic, copy) NSString * wxIcon; //微信头像
@property (nonatomic, copy) NSString * wxUID; //微信uid
@property (nonatomic, copy) NSString * wxOpenID; //微信openid
@property (nonatomic, copy) NSString * wxUnionID; //微信unionid
@property (nonatomic, strong) NSDictionary * wxOriginalResponse; //微信用户相关信息
@property (nonatomic, copy) NSString * unionGender; //微信性别 例：男
@property (nonatomic, copy) NSString * gender; //微信性别 例：m

- (void)configWithDictionary:(NSDictionary *)userInfo;

- (void)configWithUMengResponse:(UMSocialUserInfoResponse *)response;

- (BOOL)saveUserInfo;

- (void)canleLogin;

@end
