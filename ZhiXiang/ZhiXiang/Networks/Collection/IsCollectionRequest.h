//
//  IsCollectionRequest.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/25.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface IsCollectionRequest : BGNetworkRequest

- (instancetype)initWithDailyid:(NSString *)dailyid;

@end
