//
//  IsCollectionRequest.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/25.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "IsCollectionRequest.h"
#import "Helper.h"

@implementation IsCollectionRequest

- (instancetype)initWithDailyid:(NSString *)dailyid{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Collection/isCollected?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:dailyid forParamKey:@"dailyid"];
    }
    return self;
}

@end
