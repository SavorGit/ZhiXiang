//
//  MyCollectionModel.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface MyCollectionModel : Jastor

// 真实接口数据 （全部文章列表）
@property(nonatomic, strong) NSString *bespeak_time;
@property(nonatomic, strong) NSString *dailyid;
@property(nonatomic, strong) NSString *imgUrl;
@property(nonatomic, strong) NSString *sourceName;
@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) NSString *collecTime;//用于收藏列表











///////////////////////////////////////////////////
@property(nonatomic, assign) NSString * artid;
@property(nonatomic, strong) NSString *sort_num;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, assign) NSInteger imgStyle;
//@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *contentURL;
//@property(nonatomic, strong) NSString *sourceName;
@property(nonatomic, strong) NSString *logo;
@property(nonatomic, strong) NSString *indexImageUrl;

@property (nonatomic, copy) NSString * updateTime;


@end
