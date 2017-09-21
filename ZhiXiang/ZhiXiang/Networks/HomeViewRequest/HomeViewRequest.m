//
//  HomeViewRequest.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeViewRequest.h"
#import "Helper.h"

@implementation HomeViewRequest

- (instancetype)initWithIBespeakTime:(NSString *)bespeak_time;
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Index/getList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:bespeak_time forParamKey:@"bespeak_time"];
    }
    return self;
}

@end
