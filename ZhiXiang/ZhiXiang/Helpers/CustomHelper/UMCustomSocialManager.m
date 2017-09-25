//
//  UMCustomSocialManager.m
//  SavorX
//
//  Created by 郭春城 on 16/11/30.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "UMCustomSocialManager.h"
#import <UShareUI/UShareUI.h>
#import "GCCKeyChain.h"
#import "SDImageCache.h"
#import "Helper.h"
#import "MBProgressHUD+Custom.h"

@interface UMCustomSocialManager ()

@property (nonatomic, strong) MyCollectionModel * model;
@property (nonatomic, strong) UIViewController * controller;
@property (nonatomic, copy) NSString * info;

@end

@implementation UMCustomSocialManager

+ (UMCustomSocialManager *)defaultManager
{
    static dispatch_once_t once;
    static UMCustomSocialManager *manager;
    dispatch_once(&once, ^ {
        manager = [[UMCustomSocialManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.info = @"热点聚焦 , 投你所好";
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_WechatFavorite), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone), @(UMSocialPlatformType_Sina)]];
    }
    return self;
}

/**
 *  每日知享1.0改版调用
 */
- (void)sharedToPlatform:(UMSocialPlatformType)platformType andController:(UIViewController *)VC withModel:(MyCollectionModel *)model andUmKeyString:(NSString *)keyString;
{
    self.model = model;
    NSString * url = [[Helper addURLParamsShareWith:self.model.contentURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.model.imageURL];
    UIImage * image = [UIImage imageNamed:@"shareDefalut"];
    self.info = @"热点聚焦 , 投你所好";
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页分享类型
    UMShareWebpageObject * object = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@ - %@", @"小热点", self.model.title] descr:self.info thumImage:image];
    [object setWebpageUrl:url];
    messageObject.shareObject = object;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:VC completion:^(id result, NSError *error) {
        
        if (error) {
            [MBProgressHUD showTextHUDWithText:@"分享失败" inView:VC.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"分享失败" inView:VC.view];
        }
        
    }];
}

@end
