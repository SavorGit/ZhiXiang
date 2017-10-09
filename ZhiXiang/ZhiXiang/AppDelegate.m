//
//  AppDelegate.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "HomeViewController.h"
#import "ZXBaseNavigationController.h"
#import "ZXTools.h"
#import "ZXLGViewController.h"
#import "UMCustomSocialManager.h"

@interface AppDelegate ()

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    
    [ZXTools configApplication];
    
    [self createHomeViewController];
    
    return YES;
}

- (void)createHomeViewController
{
    HomeViewController * home = [[HomeViewController alloc] init];
    ZXBaseNavigationController * homeNav = [[ZXBaseNavigationController alloc] initWithRootViewController:home];
    LeftViewController * left = [[LeftViewController alloc] init];
    ZXLGViewController * menu = [[ZXLGViewController alloc] initWithRootViewController:homeNav leftViewController:left rightViewController:nil];
    menu.rootViewStatusBarStyle = UIStatusBarStyleDefault;
    
    self.window.rootViewController = menu;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.backgroundColor = [UIColor whiteColor];
    if (isiPhone_X) {
        
        UIImageView *iphoneX_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height - 34)];
        iphoneX_imageView.contentMode = UIViewContentModeScaleAspectFill;
        [iphoneX_imageView setImage:[UIImage imageNamed:@"launchImage375x667"]];
        [imageView addSubview:iphoneX_imageView];
        
    }else{
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImage:[UIImage imageNamed:@"launchImage375x667"]];
    }
    
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:imageView];
    [self.window bringSubviewToFront:imageView];
    [ZXTools postUMHandleWithContentId:@"news_share_start" key:@"news_share_start" value:@"success"];
    
    [UIView animateWithDuration:2.f animations:^{
        
        imageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        menu.rootViewStatusBarStyle = UIStatusBarStyleLightContent;
        [menu setNeedsStatusBarAppearanceUpdate];
        
        home.canShowKeyWords = YES;
        [home showKeyWord];
        
        [UIView animateWithDuration:.5f animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
        
    }];
}

//通过其它应用打开APP时调用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        if (options) {
            NSString * path = [[url description] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [OpenFileTool screenFileWithPath:path];
        }
        return YES;
    }
    return result;
}


//iOS老版系统通过其他应用调取打开
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        if (url) {
            NSString * path = [[url description] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [OpenFileTool screenFileWithPath:path];
        }
        return YES;
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSTimeInterval lastTime = self.lastTime;
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diatanceTime = self.lastTime - lastTime;
    
    //设置应用进入后台后的假重启时间
    if (diatanceTime > 30.f) {
        [self createHomeViewController];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
