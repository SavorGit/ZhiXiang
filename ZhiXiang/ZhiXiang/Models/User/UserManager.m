//
//  UserManager.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static UserManager * instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)configWithDictionary:(NSDictionary *)userInfo
{
    self.isLogin = YES;
}

@end
