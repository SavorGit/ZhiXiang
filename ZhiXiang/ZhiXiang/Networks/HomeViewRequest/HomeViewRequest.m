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

- (instancetype)initWithId:(NSString *)cid;
{
    if (self = [super init]) {
        self.methodName = [@"APP3/Special/specialGroupDetail?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(cid)) {
            [self setValue:cid forParamKey:@"id"];
        }
    }
    return self;
}

@end
