//
//  MyCollectionRequest.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MyCollectionRequest.h"
#import "Helper.h"

@implementation MyCollectionRequest

- (instancetype)initWithCollecTime:(NSString *)collecTime;
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Collection/getMyCollection?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:collecTime forParamKey:@"collecTime"];
    }
    return self;
}

@end
