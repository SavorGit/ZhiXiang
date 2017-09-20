//
//  AllArticelRequest.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface AllArticelRequest : BGNetworkRequest

- (instancetype)initWithBespeakTime:(NSString *)besTime;

//- (instancetype)initWithCateId:(NSInteger )cateId withSortNum:(NSString *)sortNum;

@end
