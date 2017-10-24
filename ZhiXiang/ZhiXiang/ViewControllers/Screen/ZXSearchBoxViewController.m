//
//  ZXSearchBoxViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXSearchBoxViewController.h"
#import "GCCDLNA.h"

@interface ZXSearchBoxViewController ()

@property (nonatomic, strong) GCCDLNA * dlna;

@end

@implementation ZXSearchBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dlna = [[GCCDLNA alloc] init];
    [self.dlna startSearchPlatform];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dlna stopSearchDeviceWithNetWorkChange];
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
