//
//  MyCollectionModel.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface MyCollectionModel : Jastor

@property(nonatomic, assign) NSString * artid;
@property(nonatomic, strong) NSString *sort_num;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, assign) NSInteger imgStyle;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *contentURL;
@property(nonatomic, strong) NSString *sourceName;
@property(nonatomic, strong) NSString *logo;
@property(nonatomic, strong) NSString *indexImageUrl;

@property (nonatomic, copy) NSString * updateTime;

@end
