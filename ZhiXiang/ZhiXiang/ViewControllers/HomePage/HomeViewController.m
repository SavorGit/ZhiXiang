//
//  HomeViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeViewController.h"
#import "TYCyclePagerView.h"
#import "HomeCollectionViewCell.h"
#import "HomeStatusCollectionViewCell.h"
#import "ZXKeyWordsView.h"
#import "HomeDetailView.h"
#import "HomeViewRequest.h"
#import "UIViewController+LGSideMenuController.h"
#import "HomeDateView.h"
#import "MBProgressHUD+Custom.h"
#import "HomeKeyWordRequest.h"

@interface HomeViewController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, HomeStatusCellDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) UIView * maskView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSDictionary * detailDataDic; //数据源

@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) NSArray * keyWords;

@property (nonatomic, strong) HomeDateView * dateView;

@property (nonatomic, strong) HomeStatusCollectionViewCell * statusCell;

@property (nonatomic, assign) BOOL isNoMoreData;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self setupNavigatinBar];
    [self setupViews];
    [self dataRequest];
}

- (void)setupNavigatinBar
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
}

- (void)leftButtonDidClicked
{
    [self showLeftViewAnimated:nil];
}

- (void)initInfor{
    _detailDataDic = [[NSDictionary alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
}

- (void)setupViews
{
    self.view.backgroundColor = UIColorFromRGB(0x222222);
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 25, kMainBoundsHeight - 64)];
    self.maskView.backgroundColor =UIColorFromRGB(0x222222);
    
    LGSideMenuController * LGSide = self.sideMenuController;
    
    LGSide.willShowLeftView = ^(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view) {
        [self.view addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(80);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
            make.width.mas_equalTo(28);
        }];
        self.canShowKeyWords = NO;
    };
    LGSide.willHideLeftView = ^(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view) {
        [self.maskView removeFromSuperview];
    };
    
    self.pagerView = [[TYCyclePagerView alloc]init];
    self.pagerView.isInfiniteLoop = NO;
    self.pagerView.dataSource = self;
    self.pagerView.delegate = self;
    [self.pagerView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.pagerView registerClass:[HomeStatusCollectionViewCell class] forCellWithReuseIdentifier:@"HomeStatusCollectionViewCell"];
    
    [self.view addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-70);
        make.right.mas_equalTo(0);
    }];
    self.currentIndex = 0;
    
    [self.pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.dataSource.count + 1;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    
    if (index < self.dataSource.count) {
        HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
        HomeCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndex:index];
        [cell configModelData:tmpModel];
        return cell;
    }else{
        HomeStatusCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeStatusCollectionViewCell" forIndex:index];
        self.statusCell = cell;
        self.statusCell.delegate = self;
        if (self.isRequest) {
            [self.statusCell showLoading];
        }
        
        return cell;
    }
}

- (void)HomeStatusDidBeRetryLoadData
{
    [self dataRequest];
}

- (void)startLoadMoreData
{
    if (self.isRequest || self.isNoMoreData) {
        return;
    }
    
    self.isRequest = YES;
    if (self.statusCell) {
        [self.statusCell showLoading];
    }
    
    HomeViewModel *tmpModel = [self.dataSource lastObject];
    NSDictionary * dict = tmpModel.detailDic;
    HomeViewRequest * request = [[HomeViewRequest alloc] initWithIBespeakTime:[dict objectForKey:@"bespeak_time"]];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
        NSArray *listArr = [dataDict objectForKey:@"list"];
        
        if (!listArr || listArr.count == 0) {
            if (self.statusCell) {
                [self.statusCell showNoMoreData];
            }
            self.isNoMoreData = YES;
            self.isRequest = NO;
            return;
        }
        
        for (int i = 0; i < listArr.count; i ++) {
            NSDictionary *tmpDic = [listArr objectAtIndex:i];
            HomeViewModel *tmpModel = [[HomeViewModel alloc] initWithDictionary:tmpDic];
            tmpModel.detailDic = [tmpDic objectForKey:@"contentDetail"];
            tmpModel.day = [dataDict objectForKey:@"day"];
            tmpModel.month = [dataDict objectForKey:@"month"];
            tmpModel.week = [dataDict objectForKey:@"week"];
            [self.dataSource addObject:tmpModel];
            NSLog(@"%@",tmpDic);
        }
        
        [self.pagerView reloadData];
        self.isRequest = NO;
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (self.statusCell) {
            [self.statusCell showNoNetWork];
        }
        self.isRequest = NO;
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        if (self.statusCell) {
            [self.statusCell showNoNetWork];
        }
        self.isRequest = NO;
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    }];
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kMainBoundsWidth - 60, kMainBoundsHeight - kStatusBarHeight - kNaviBarHeight - 30 - 70);
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (index < self.dataSource.count && index == self.currentIndex) {
        self.canShowKeyWords = NO;
        HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
        CGRect detailViewFrame = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
        HomeDetailView * detailView = [[HomeDetailView alloc] initWithFrame:detailViewFrame andData:tmpModel];
        [[UIApplication sharedApplication].keyWindow addSubview:detailView];
        [detailView becomeScreenToRead];
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.currentIndex = toIndex;
    if (toIndex >= self.dataSource.count - 4) {
        [self startLoadMoreData];
    }
    if (toIndex < self.dataSource.count) {
        HomeViewModel * model = [self.dataSource objectAtIndex:toIndex];
        if (model) {
            [self.dateView configWithModel:model];
        }
    }
}

- (void)dataRequest{
    
    if (self.isRequest) {
        return;
    }
    
    self.isRequest = YES;
    if (self.statusCell) {
        [self.statusCell showLoading];
    }
    
    HomeViewRequest * request = [[HomeViewRequest alloc] initWithIBespeakTime:nil];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
        NSArray *listArr = [dataDict objectForKey:@"list"];
        
        if (!listArr || listArr.count == 0) {
            if (self.statusCell) {
                [self.statusCell showNoMoreData];
            }
            self.isNoMoreData = YES;
            self.isRequest = NO;
            return;
        }
        
        for (int i = 0; i < listArr.count; i ++) {
            NSDictionary *tmpDic = [listArr objectAtIndex:i];
            HomeViewModel *tmpModel = [[HomeViewModel alloc] initWithDictionary:tmpDic];
            tmpModel.detailDic = [tmpDic objectForKey:@"contentDetail"];
            [self.dataSource addObject:tmpModel];
            tmpModel.day = [dataDict objectForKey:@"day"];
            tmpModel.month = [dataDict objectForKey:@"month"];
            tmpModel.week = [dataDict objectForKey:@"week"];
            
            if (i == 0) {
                [self.dateView configWithModel:tmpModel];
            }
            
            NSLog(@"%@",tmpDic);
        }
        
        [self.pagerView reloadData];
        self.isRequest = NO;
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (self.statusCell) {
            [self.statusCell showNoNetWork];
        }
        self.isRequest = NO;
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        if (self.statusCell) {
            [self.statusCell showNoNetWork];
        }
        self.isRequest = NO;
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
    }];
    
    HomeKeyWordRequest * keyWordRequest = [[HomeKeyWordRequest alloc] init];
    [keyWordRequest sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        NSArray * list = [response objectForKey:@"result"];
        if (list && [list isKindOfClass:[NSArray class]]) {

            self.keyWords = [NSArray arrayWithArray:list];
            [self showKeyWord];

        }

    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {

    }];
}

- (void)showKeyWord
{
    if (!self.canShowKeyWords) {
        return;
    }
    
    if (self.keyWords && self.keyWords.count > 0) {
        ZXKeyWordsView * keyWordView = [[ZXKeyWordsView alloc] initWithKeyWordArray:self.keyWords];
        [keyWordView showWithAnimation:YES];
        self.canShowKeyWords = NO;
        self.keyWords = nil;
    }
}

- (HomeDateView *)dateView
{
    if (!_dateView) {
        _dateView = [[HomeDateView alloc] initWithFrame:CGRectMake(0, 0, 88, 40)];
        [self.view addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(88, 40));
        }];
    }
    return _dateView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
