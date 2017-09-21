//
//  HomeViewModel.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface HomeViewModel : Jastor

@property(nonatomic, assign) NSString * artid;
@property(nonatomic, strong) NSString *sort_num;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, assign) NSInteger imgStyle;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *contentURL;
//@property(nonatomic, strong) NSString *sourceName;
@property(nonatomic, strong) NSString *logo;
@property(nonatomic, strong) NSString *indexImageUrl;

@property(nonatomic, assign) NSInteger canplay;
@property(nonatomic, assign) NSInteger duration;
@property(nonatomic, assign) NSString *mediaId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *updateTime;
@property(nonatomic, strong) NSString *videoURL;
@property (nonatomic, assign) NSInteger canPlay;
@property (nonatomic, assign) NSString *colTuJi;
@property (nonatomic, copy) NSString * createTime; //创建时间
@property (nonatomic, assign) NSInteger collected;  //0代表未收藏，1代表收藏

@property (nonatomic, copy) NSString * acreateTime;
@property (nonatomic, copy) NSString * ucreateTime;

@property (nonatomic, assign) NSInteger sgtype;//用于专题组类型
@property (nonatomic, copy) NSString * img_url;//用于专题组图片
@property (nonatomic, copy) NSString * stitle;//用于专题组小标题
//@property (nonatomic, copy) NSString * stext;//用于专题组文字内容
@property (nonatomic, copy) NSString * desc;//用于专题组头部描述

//非接口返回
@property (nonatomic, assign) NSInteger cid;
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

@end
