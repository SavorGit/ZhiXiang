//
//  HomeViewModel.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

typedef enum : NSUInteger {
    HomeViewModelType_Default,
    HomeViewModelType_Command,
    HomeViewModelType_PageGuide
} HomeViewModelType;

@interface HomeViewModel : Jastor

@property (nonatomic, assign) HomeViewModelType modelType;

@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, copy) NSString * img_url;

@property (nonatomic, assign) NSInteger shareType;//非接口返回，用于分享类型(1代表专题组首页分享)

@property (nonatomic, assign) NSInteger contentType;

//文章详情
@property(nonatomic, copy) NSString *dailyid;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *sourceName;
@property(nonatomic, copy) NSString *bespeak_time;
@property(nonatomic, assign) NSInteger is_collect;
@property(nonatomic, assign) NSInteger dailytype;
@property(nonatomic, copy) NSString *stext;
@property(nonatomic, copy) NSString *spicture;
@property(nonatomic, copy) NSString *share_url;

@property(nonatomic, copy) NSString *week;
@property(nonatomic, copy) NSString *month;
@property(nonatomic, copy) NSString *day;

@property(nonatomic, strong) NSDictionary *detailDic;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;

@property(nonatomic, copy) NSString * artpro;

//HomeViewModelType_PageGuide
@property(nonatomic, copy) NSString *dailyauthor;
@property(nonatomic, copy) NSString * dailyart;
@property(nonatomic, copy) NSString * nextMonth;
@property(nonatomic, copy) NSString * nextWeek;
@property(nonatomic, copy) NSString * nextDay;

@end
