//
//  GetDailyConfigRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetDailyConfigRequest.h"
#import "Helper.h"

@implementation GetDailyConfigRequest

- (instancetype)init{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Config/getdailyconfig?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPGet;
    }
    return self;
}

@end
