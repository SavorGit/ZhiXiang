//
//  ZXBaseNavigationController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXBaseNavigationController.h"
#import "UIImage+Additional.h"

@interface ZXBaseNavigationController ()

@end

@implementation ZXBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(kMainBoundsWidth, kNaviBarHeight + kStatusBarHeight)];
    [[UINavigationBar appearanceWhenContainedIn:[ZXBaseNavigationController class], nil] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
}


- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
