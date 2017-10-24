//
//  leftMenuModel.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MenuModelType_Collect,
    MenuModelType_All,
    MenuModelType_Cache,
    MenuModelType_Screen
} MenuModelType;

@interface leftMenuModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, assign) MenuModelType type;

@end
