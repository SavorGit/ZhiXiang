//
//  WeixinLoginRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "WeixinLoginRequest.h"
#import "Helper.h"

@implementation WeixinLoginRequest

- (instancetype)initWithDailyid:(NSString *)openid ptype:(NSString *)ptype tel:(NSString *)tel
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Login/weixinLogin?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:openid forParamKey:@"openid"];
        [self setValue:ptype forParamKey:@"ptype"];
        
        if (!isEmptyString(tel)) {
            [self setValue:tel forParamKey:@"tel"];
        }
        
    }
    return self;
}

@end
