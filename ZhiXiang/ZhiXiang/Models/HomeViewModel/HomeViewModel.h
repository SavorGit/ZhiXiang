//
//  HomeViewModel.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface HomeViewModel : Jastor

@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, copy) NSString * img_url;

@property (nonatomic, assign) NSInteger shareType;//非接口返回，用于分享类型(1代表专题组首页分享)

@property (nonatomic, assign) NSInteger contentType;

//文章详情
@property(nonatomic, strong) NSString *dailyid;
@property(nonatomic, strong) NSString *imgUrl;
@property(nonatomic, strong) NSString *sourceName;
@property(nonatomic, strong) NSString *bespeak_time;
@property(nonatomic, assign) NSInteger is_collect;
@property(nonatomic, assign) NSInteger dailytype;
@property(nonatomic, strong) NSString *stext;
@property(nonatomic, strong) NSString *spicture;


@property(nonatomic, strong) NSString *week;
@property(nonatomic, strong) NSString *month;
@property(nonatomic, strong) NSString *day;

@property(nonatomic, strong) NSDictionary *detailDic;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *desc;

@end
