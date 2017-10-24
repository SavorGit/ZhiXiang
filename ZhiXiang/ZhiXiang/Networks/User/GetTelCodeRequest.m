//
//  GetTelCodeRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetTelCodeRequest.h"
#import "Helper.h"

@implementation GetTelCodeRequest

- (instancetype)initWith:(NSString *)telNumber
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Login/getverifyCode?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:telNumber forParamKey:@"tel"];
    }
    return self;
}

@end
