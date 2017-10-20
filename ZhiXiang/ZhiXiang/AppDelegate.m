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
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "UserNotificationModel.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) UIView * asSetView;
@property (nonatomic, strong) NSMutableArray *asSetsArray;
@property (nonatomic, copy)   NSString *selectSetString;
@property (nonatomic, strong) UIButton *goButton;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    
    [ZXTools configApplication];
    //初始化推送
    [self handleLaunchWorkWithOptions:launchOptions];
    
    [self createHomeViewController];
    
    return YES;
}

//处理启动时候的相关事务
- (void)handleLaunchWorkWithOptions:(NSDictionary *)launchOptions
{
    //友盟推送
    [UMessage startWithAppkey:UmengAppkey launchOptions:launchOptions];
    [UMessage setAutoAlert:NO];
    [UMessage registerForRemoteNotifications];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|    UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];
    }
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assetString = [defaults objectForKey:@"asSetValue"];
    if (isEmptyString(assetString)) {
        [self creatAssetsUI:imageView];
    }
    [ZXTools postUMHandleWithContentId:@"news_share_start" key:@"news_share_start" value:@"success"];
    
    [UIView animateWithDuration:2.f animations:^{
        
        imageView.transform = CGAffineTransformMakeScale(1.08, 1.08);
        
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

- (void)creatAssetsUI:(UIImageView *)imgView{
    
    self.asSetView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.asSetView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    topImgView.image = [UIImage imageNamed:@"zichan"];
    topImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.asSetView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85);
        make.centerX.mas_equalTo(self.asSetView.mas_centerX);
        make.width.mas_equalTo(topImgView.mas_width);
        make.height.mas_equalTo(topImgView.mas_height);
    }];
    
    UILabel *selectTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    selectTitle.font = kPingFangRegular(15);
    selectTitle.text = @"请选择您所在的群体";
    selectTitle.textColor = UIColorFromRGB(0x555555);
    selectTitle.textAlignment = NSTextAlignmentCenter;
    [self.asSetView addSubview:selectTitle];
    [selectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImgView.mas_bottom).offset(60);
        make.centerX.mas_equalTo(self.asSetView.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    NSArray *assetsArray = [NSArray arrayWithObjects:@"资产10亿以上",@"资产1亿以上",@"资产一千万以上",@"暂不透露", nil];
    self.asSetsArray = [[NSMutableArray alloc] init];
    self.selectSetString = [[NSString alloc] init];
    for (int i = 0; i < 4; i ++) {
        UIButton *asSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        asSetButton.tag = i + 1;
        asSetButton.layer.cornerRadius = 3;
        asSetButton.layer.masksToBounds = YES;
        asSetButton.layer.borderWidth = 1;
        asSetButton.layer.borderColor = UIColorFromRGB(0xcecece).CGColor;
        [asSetButton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [asSetButton setTitle:[assetsArray objectAtIndex:i] forState:UIControlStateNormal];
        [asSetButton addTarget:self action:@selector(asSetPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.asSetView addSubview:asSetButton];
        [asSetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(selectTitle.mas_bottom).offset(32 + i *15 + i *44);
            make.centerX.mas_equalTo(self.asSetView.mas_centerX);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(44);
        }];
        [self.asSetsArray addObject:asSetButton];
    }
    
    self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goButton.backgroundColor = UIColorFromRGB(0xcccccc);
    self.goButton.layer.cornerRadius = 5;
    self.goButton.layer.masksToBounds = YES;
    [self.goButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.goButton setTitle:@"进入" forState:UIControlStateNormal];
    [self.goButton addTarget:self action:@selector(goPress:) forControlEvents:UIControlEventTouchUpInside];
    self.goButton.userInteractionEnabled = NO;
    [self.asSetView addSubview:self.goButton];
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.asSetView.mas_bottom).offset(- 65);
        make.centerX.mas_equalTo(self.asSetView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(36);
    }];
    
    [self.window addSubview:self.asSetView];
    [self.window insertSubview:self.asSetView belowSubview:imgView];

}

- (void)asSetPress:(UIButton *)asBtn{
    
    for (int i = 0 ; i < self.asSetsArray.count; i ++) {
        UIButton *btn = self.asSetsArray[i];
        btn.layer.borderColor = UIColorFromRGB(0xcecece).CGColor;
    }
    asBtn.layer.borderColor = UIColorFromRGB(0x000000).CGColor;
    self.goButton.backgroundColor = UIColorFromRGB(0x333333);
    self.goButton.userInteractionEnabled = YES;
    self.selectSetString = [NSString stringWithFormat:@"%ld", asBtn.tag];
    
}

- (void)goPress:(UIButton *)goBtn{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.selectSetString forKey:@"asSetValue"];
    [defaults synchronize];
    
    [UIView animateWithDuration:3.f animations:^{
        self.asSetView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.asSetView removeFromSuperview];
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

//app注册推送deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@",token);
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    [self didReceiveNotificationWithInfo:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self didReceiveNotificationWithInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)didReceiveNotificationWithInfo:(NSDictionary *)userInfo
{
    NSString * jsonStr = [userInfo objectForKey:@"params"];
    
    if (isEmptyString(jsonStr)) {
        return;
    }
    
    NSDictionary * data = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if ([data isKindOfClass:[NSDictionary class]] && data.count > 0) {
        
        UserNotificationModel * model = [[UserNotificationModel alloc] initWithDictionary:data];
        
        if (!isEmptyString(model.error_id)) {
            
            NSLog(@"%@",data);
            //跳转处理
        }
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    self.lastTime = [[NSDate date] timeIntervalSince1970];
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
    
    NSTimeInterval lastTime = self.lastTime;
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diatanceTime = self.lastTime - lastTime;
    
    //设置应用进入后台后的假重启时间
    if (diatanceTime > 600.f) {
        [self createHomeViewController];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
