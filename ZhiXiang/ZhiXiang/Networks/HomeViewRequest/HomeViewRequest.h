//
//  HomeViewRequest.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface HomeViewRequest : BGNetworkRequest

- (instancetype)initWithIBespeakTime:(NSString *)bespeak_time;

@end
