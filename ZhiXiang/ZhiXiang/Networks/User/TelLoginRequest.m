//
//  TelLoginRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TelLoginRequest.h"
#import "Helper.h"

@implementation TelLoginRequest

- (instancetype)initWithTel:(NSString *)telNumber ptype:(NSString *)type code:(NSString *)code openid:(NSString *)openid
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Login/mobileLogin?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:type forParamKey:@"ptype"];
        [self setValue:code forParamKey:@"verifycode"];
        [self setValue:telNumber forParamKey:@"tel"];
        
        if (!isEmptyString(openid)) {
            [self setValue:openid forParamKey:@"openid"];
        }
        
    }
    return self;
}

@end
