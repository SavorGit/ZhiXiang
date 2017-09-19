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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
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
    
    [self.window makeKeyAndVisible];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImage:[UIImage imageNamed:@"launchImage375x667"]];
    [self.window addSubview:imageView];
    
    [UIView animateWithDuration:2.f animations:^{
        
        imageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        menu.rootViewStatusBarStyle = UIStatusBarStyleLightContent;
        [menu setNeedsStatusBarAppearanceUpdate];
        
        [UIView animateWithDuration:.5f animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
