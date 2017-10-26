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
#import "ZXTools.h"

@interface UMCustomSocialManager ()

@property (nonatomic, strong) HomeViewModel * model;
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
- (void)sharedToPlatform:(UMSocialPlatformType)platformType andController:(UIViewController *)VC  andView:(UIView *)view  withModel:(HomeViewModel *)model andUmKeyString:(NSString *)keyString;
{
    self.model = model;
    NSString * url = [[Helper addURLParamsShareWith:self.model.share_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.model.imageURL];
    UIImage * image = [UIImage imageNamed:@"shareDefalut"];
    self.info = @"每日知享";
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页分享类型
    UMShareWebpageObject * object = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@ - %@", self.info, self.model.title] descr:self.model.desc thumImage:image];
    [object setWebpageUrl:url];
    messageObject.shareObject = object;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:VC completion:^(id result, NSError *error) {
        
        [ZXTools postUMHandleWithContentId:@"news_share_detail_toshare_finish" key:nil value:nil];
        if (error) {
            [ZXTools postUMHandleWithContentId:keyString key:keyString value:@"fail"];
            [MBProgressHUD showTextHUDWithText:@"分享失败" inView:view];
        }else{
            [ZXTools postUMHandleWithContentId:keyString key:keyString value:@"success"];
            [MBProgressHUD showTextHUDWithText:@"分享成功" inView:view];
        }
        
    }];
}

- (void)sharedAPPToPlatform:(UMSocialPlatformType)platformType andController:(UIViewController *)VC andView:(UIView *)view andUmKeyString:(NSString *)keyString
{
    NSString * url = @"https://itunes.apple.com/cn/app/id1284095616";
    UIImage * image = [UIImage imageNamed:@"shareDefalut"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页分享类型
    UMShareWebpageObject * object = [UMShareWebpageObject shareObjectWithTitle:@"每日知享，高端人士的内容管家" descr:@"每日精选十条内容\n高效  价值  品位" thumImage:image];
    [object setWebpageUrl:url];
    messageObject.shareObject = object;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:VC completion:^(id result, NSError *error) {
        
        if (error) {
            [MBProgressHUD showTextHUDWithText:@"分享失败" inView:view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"分享成功" inView:view];
        }
        
    }];
}

@end
