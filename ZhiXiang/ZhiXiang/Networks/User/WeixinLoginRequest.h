//
//  WeixinLoginRequest.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface WeixinLoginRequest : BGNetworkRequest

- (instancetype)initWithDailyid:(NSString *)openid ptype:(NSString *)ptype tel:(NSString *)tel;

@end