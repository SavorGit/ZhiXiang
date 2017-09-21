//
//  HomeDetailRequest.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface HomeDetailRequest : BGNetworkRequest

- (instancetype)initWithDailyid:(NSString *)dailyid;

@end
