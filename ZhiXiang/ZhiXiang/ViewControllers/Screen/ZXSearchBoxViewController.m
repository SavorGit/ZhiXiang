//
//  ZXSearchBoxViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/10/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXSearchBoxViewController.h"
#import "MBProgressHUD+Custom.h"
#import "RDKeyBoard.h"
#import "GCCDLNA.h"
#import "Helper.h"
//#import "ResSliderViewController.h"
//#import "RestaurantPhotoTool.h"

@interface ZXSearchBoxViewController ()<RDKeyBoradDelegate>

@property (nonatomic, strong) GCCDLNA * dlna;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) NSMutableArray * labelSource;
@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) NSMutableString *keyMuSring;

@end

@implementation ZXSearchBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"餐厅投屏";
    self.view.backgroundColor = UIColorFromRGB(0xf8f6f1);
    self.labelSource = [[NSMutableArray alloc] init];
    self.keyMuSring = [[NSMutableString alloc] initWithString:@""];
    
    [self createViews];
    
    [MBProgressHUD showLoadingHUDWithText:@"正在搜索投屏设备..." inView:self.view];
    self.dlna = [[GCCDLNA alloc] init];
    [self.dlna startSearchPlatform];
    
    [self performSelector:@selector(searchResult) withObject:nil afterDelay:10.f];
}

- (void)createViews
{
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    if (kMainBoundsHeight == 568) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.textLabel.font = [UIFont systemFontOfSize:17];
    }
    self.textLabel.text = @"请输入电视中的三位数连接电视";
    self.textLabel.textColor = UIColorFromRGB(0x333333);
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
    }];
    
    for (NSInteger i = 0; i < 3; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.layer.cornerRadius = 0;
        label.layer.borderColor = UIColorFromRGB(0xffd237).CGColor;
        label.layer.borderWidth = 1.5f;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont boldSystemFontOfSize:30];
        [self.view addSubview:label];
        float distance = [Helper autoHeightWith:99];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kMainBoundsHeight == 568) {
                make.top.mas_equalTo (self.textLabel.mas_bottom).offset(20);
            }else{
                make.top.mas_equalTo (self.textLabel.mas_bottom).offset(25);
            }
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:70],[Helper autoHeightWith:50]));
            if (i == 0) {
                make.centerX.mas_equalTo(-distance);
            }else if (i == 1) {
                make.centerX.mas_equalTo(0);
            }else{
                make.centerX.mas_equalTo(distance);
            }
        }];
        [self.labelSource addObject:label];
    }
    
    RDKeyBoard *keyBoard;
    if (kMainBoundsHeight == 736) {
        keyBoard = [[RDKeyBoard alloc] initWithHeight:226.0 inView:self.view];
    }else{
        keyBoard = [[RDKeyBoard alloc] initWithHeight:216.0 inView:self.view];
    }
    keyBoard.delegate = self;
    
    self.blackView = [[UIView alloc] initWithFrame:CGRectZero];
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    [self.view addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)RDKeyBoradViewDidClickedWith:(NSString *)str isDelete:(BOOL)isDelete{
    
    if (isDelete == YES ) {
        if (self.keyMuSring.length >= 1) {
            [self.keyMuSring deleteCharactersInRange:NSMakeRange(self.keyMuSring.length - 1,1)];
        }else{
            return;
        }
    }else{
        [self.keyMuSring appendString:str];
    }
    
    NSString * number = self.keyMuSring;
    
    for (NSUInteger i = 0; i < self.labelSource.count; i++) {
        if (i < number.length) {
            UILabel * label = [self.labelSource objectAtIndex:i];
            label.text = [number substringWithRange:NSMakeRange(i, 1)];
        }else{
            UILabel * label = [self.labelSource objectAtIndex:i];
            label.text = @"";
        }
    }
    
    if (number.length == self.labelSource.count) {
        
        [self didBindDevice];
        
    }else if (number.length > self.labelSource.count) {
        [self.keyMuSring deleteCharactersInRange:NSMakeRange(3, number.length - 3)];
    }
}

- (void)didBindDevice
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在绑定" inView:self.navigationController.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [MBProgressHUD showSuccessWithText:@"绑定成功" inView:self.navigationController.view];
//        [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
//            ResSliderViewController * res = [[ResSliderViewController alloc] init];
//            [self.navigationController pushViewController:res animated:YES];
//        } failure:^(NSError *error) {
//
//        }];
    });
}

- (void)searchResult
{
    BOOL success = NO;
    
    if (success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccessWithText:@"发现可连接设备" inView:self.view];
        [UIView animateWithDuration:.2f animations:^{
            self.blackView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.blackView removeFromSuperview];
        }];
    }else{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDWithText:@"未发现可投屏设备" inView:self.navigationController.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchResult) object:nil];
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
