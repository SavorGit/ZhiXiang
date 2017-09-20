//
//  AllArticelRequest.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AllArticelRequest.h"
#import "Helper.h"

@implementation AllArticelRequest

- (instancetype)initWithBespeakTime:(NSString *)besTime
{
    if (self = [super init]) {
        self.methodName = [@"Dailyknowledge/Content/getAllList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:besTime forParamKey:@"bespeak_time"];
    }
    return self;
}

//- (instancetype)initWithCateId:(NSInteger )cateId withSortNum:(NSString *)sortNum;
//{
//    if (self = [super init]) {
//        self.methodName = [@"APP3/Content/getLastCategoryList?" stringByAppendingString:[Helper getURLPublic]];
//        self.httpMethod = BGNetworkRequestHTTPPost;
//        [self setValue:[NSString stringWithFormat:@"%ld",cateId] forParamKey:@"cateid"];
//        [self setValue:sortNum forParamKey:@"sort_num"];
//    }
//    return self;
//}

@end
