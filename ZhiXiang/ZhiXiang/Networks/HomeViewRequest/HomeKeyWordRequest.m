//
//  HomeKeyWordRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeKeyWordRequest.h"
#import "Helper.h"

@implementation HomeKeyWordRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Keywords/getAllKeywords?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
