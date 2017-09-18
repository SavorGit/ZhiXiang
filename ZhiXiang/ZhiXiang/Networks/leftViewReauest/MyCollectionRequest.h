//
//  MyCollectionRequest.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface MyCollectionRequest : BGNetworkRequest

- (instancetype)initWithCateId:(NSInteger )cateId withSortNum:(NSString *)sortNum;

@end
