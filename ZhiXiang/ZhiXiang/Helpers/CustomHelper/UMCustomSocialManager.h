//
//  UMCustomSocialManager.h
//  SavorX
//
//  Created by 郭春城 on 16/11/30.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import "HomeViewModel.h"

@interface UMCustomSocialManager : NSObject

/**
 *  单例  用户管理友盟分享视图
 */
+ (UMCustomSocialManager *)defaultManager;

/**
 *  分享至平台3.0改版调用
 */
- (void)sharedToPlatform:(UMSocialPlatformType)platformType andController:(UIViewController *)VC andView:(UIView *)view withModel:(HomeViewModel *)model andUmKeyString:(NSString *)keyString;

/**
 *  分享至平台3.0改版调用
 */
- (void)sharedAPPToPlatform:(UMSocialPlatformType)platformType andController:(UIViewController *)VC andView:(UIView *)view andUmKeyString:(NSString *)keyString;

@end
