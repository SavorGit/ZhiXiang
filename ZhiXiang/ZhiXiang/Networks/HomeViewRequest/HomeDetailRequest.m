//
//  HomeDetailRequest.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeDetailRequest.h"
#import "Helper.h"

@implementation HomeDetailRequest

- (instancetype)initWithDailyid:(NSString *)dailyid
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Content/getDetail?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:dailyid forParamKey:@"dailyid"];
    }
    return self;
}

@end
