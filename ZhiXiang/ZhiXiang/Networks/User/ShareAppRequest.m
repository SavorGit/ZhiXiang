//
//  ShareAppRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/30.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ShareAppRequest.h"
#import "Helper.h"

@implementation ShareAppRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Config/getshareApp?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
