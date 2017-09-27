//
//  ZXLGViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXLGViewController.h"

@interface ZXLGViewController ()

@end

@implementation ZXLGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
    
    CGFloat width = kMainBoundsHeight > kMainBoundsWidth ? kMainBoundsWidth : kMainBoundsHeight;
    
    self.leftViewWidth = width * 0.8 - 30;
    self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
    self.leftViewSwipeGestureEnabled = NO;
    self.rootViewLayerShadowRadius = 0.f;
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
