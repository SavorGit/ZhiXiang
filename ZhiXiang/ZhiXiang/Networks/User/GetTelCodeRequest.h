//
//  GetTelCodeRequest.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetTelCodeRequest : BGNetworkRequest

- (instancetype)initWith:(NSString *)telNumber;

@end
