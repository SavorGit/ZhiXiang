//
//  CheckUpdateRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CheckUpdateRequest.h"
#import "Helper.h"

@implementation CheckUpdateRequest

- (instancetype)init{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Version/index?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
