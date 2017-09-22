//
//  ZXLGViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXLGViewController.h"

@interface ZXLGViewController ()

@property (nonatomic, strong) UIView * maskView;

@end

@implementation ZXLGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
    self.leftViewWidth = kMainBoundsWidth * 0.8 - 30;
    self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
    self.leftViewSwipeGestureEnabled = NO;
    self.rootViewLayerShadowRadius = 0.f;
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 25, kMainBoundsHeight - 64)];
    self.maskView.backgroundColor =UIColorFromRGB(0x222222);
    
    
    __weak typeof(self) weakSelf = self;
    self.willShowLeftView = ^(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view) {
        [weakSelf.rootViewController.view addSubview:weakSelf.maskView];
        [weakSelf.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(80);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
            make.width.mas_equalTo(28);
        }];
    };
    self.willHideLeftView = ^(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view) {
        [weakSelf.maskView removeFromSuperview];
    };
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
