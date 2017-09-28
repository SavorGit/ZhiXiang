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
#import "HomePageControl.h"
#import "ZXTools.h"

@interface HomeViewController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, HomeStatusCellDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) UIView * maskView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSDictionary * detailDataDic; //数据源

@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) NSArray * keyWords;

@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) HomeDateView * dateView;

@property (nonatomic, strong) HomeStatusCollectionViewCell * statusCell;

@property (nonatomic, assign) BOOL isNoMoreData;

@property (nonatomic, assign) BOOL isRequest;

@property (nonatomic, strong) ZXKeyWordsView * keyWordView;

@property (nonatomic, strong) HomePageControl * pageControl;

@property (nonatomic, assign) BOOL isHiddenDateAndPage;
@property (nonatomic, assign) BOOL isUserClickCell;

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
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 50, 44);
    [self.leftButton setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
}

- (void)leftButtonDidClicked
{
    [self showLeftViewAnimated:nil];
    [ZXTools postUMHandleWithContentId:@"news_share_home_menu" key:nil value:nil];
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
            make.top.mas_equalTo(kStatusBarHeight + 60);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
            make.width.mas_equalTo(28);
        }];
        
        self.canShowKeyWords = NO;
    };
    LGSide.willHideLeftView = ^(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view) {
        [self.maskView removeFromSuperview];
        
        self.canShowKeyWords = YES;
    };
    
    self.pagerView = [[TYCyclePagerView alloc]init];
    self.pagerView.isInfiniteLoop = NO;
    self.pagerView.dataSource = self;
    self.pagerView.delegate = self;
    [self.pagerView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.pagerView registerClass:[HomeStatusCollectionViewCell class] forCellWithReuseIdentifier:@"HomeStatusCollectionViewCell"];
    
    [self.view addSubview:self.pagerView];
    
    CGFloat bottomDistance = 90;
    if (isiPhone_X) {
        bottomDistance += 34;
    }
    
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight + 70);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomDistance);
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
    self.isUserClickCell = YES;
    if (self.dataSource.count > 0) {
        [self startLoadMoreData];
    }else{
        [self dataRequest];
    }
}

- (void)startLoadMoreData
{
    if (self.isRequest || self.isNoMoreData || self.dataSource.count == 0) {
        return;
    }
    
    [self hiddenDateAndPage];
    
    self.isRequest = YES;
    if (self.statusCell) {
        [self.statusCell showLoading];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
                
                if (i == 0) {
                    [self.dateView configWithModel:tmpModel];
                }
                
            }
            
            [self.pagerView reloadData];
            self.isRequest = NO;
            [self showDateAndPage];
            self.isUserClickCell = NO;
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            if (self.statusCell) {
                [self.statusCell showNoNetWork];
            }
            
            if (self.isUserClickCell) {
                [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
            }
            self.isRequest = NO;
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            if (self.statusCell) {
                [self.statusCell showNoNetWork];
            }
            
            if (self.isUserClickCell) {
                [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
            }
            self.isRequest = NO;
            
        }];
    });
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    
    if (isiPhone_X) {
        layout.itemSize = CGSizeMake(kMainBoundsWidth - 60, kMainBoundsHeight - kStatusBarHeight - 70 - 90 - 34);
    }else{
        layout.itemSize = CGSizeMake(kMainBoundsWidth - 60, kMainBoundsHeight - kStatusBarHeight - 70 - 90);
    }
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (index < self.dataSource.count && index == self.currentIndex) {
        pageView.userInteractionEnabled = NO;
        HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
        [ZXTools postUMHandleWithContentId:@"news_share_home_menu" key:@"news_share_home_card_click" value:tmpModel.dailyid];
        CGRect detailViewFrame = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
        HomeDetailView * detailView = [[HomeDetailView alloc] initWithFrame:detailViewFrame andData:tmpModel andVC:self];
        [[UIApplication sharedApplication].keyWindow addSubview:detailView];
        [detailView becomeScreenToReadCompelete:^{
            pageView.userInteractionEnabled = YES;
        }];
        [ZXTools postUMHandleWithContentId:@"news_share_home_card_show" key:@"news_share_home_card_show" value:tmpModel.dailyid];
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [ZXTools postUMHandleWithContentId:@"news_share_home_card_slide" key:nil value:nil];
    self.currentIndex = toIndex;
    if (toIndex == self.dataSource.count) {
        [self startLoadMoreData];
    }
    if (toIndex < self.dataSource.count) {
        [self showDateAndPage];
        HomeViewModel * model = [self.dataSource objectAtIndex:toIndex];
        if (model) {
            [self.dateView configWithModel:model];
        }
    }
    
    [self.pageControl setCurrentIndex:toIndex % 10 + 1];
}

- (void)dataRequest{
    
    if (self.isRequest) {
        return;
    }
    
    self.isRequest = YES;
    if (self.statusCell) {
        [self.statusCell showLoading];
    }
    
    [self hiddenDateAndPage];
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
            
        }
        
        [self.pagerView reloadData];
        self.isRequest = NO;
        [self showDateAndPage];
        self.isUserClickCell = NO;
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (self.statusCell) {
            [self.statusCell showNoNetWork];
        }
        
        if (self.isUserClickCell) {
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        self.isRequest = NO;
        [self hiddenDateAndPage];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        if (self.statusCell) {
            [self.statusCell showNoNetWork];
        }
        
        if (self.isUserClickCell) {
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        self.isRequest = NO;
        [self hiddenDateAndPage];
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
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * date = [userDefaults objectForKey:@"keyWordDate"];
    if (!isEmptyString(date)) {
        NSString * keyWordDate = [ZXTools getCurrentTimeWithFormat:@"yyyy-MM-dd"];
        if ([keyWordDate isEqualToString:date]) {
            return;
        }
    }
    
    if (self.keyWords && self.keyWords.count > 0) {
        [ZXTools postUMHandleWithContentId:@"news_share_key_words_show" key:nil value:nil];
        self.keyWordView = [[ZXKeyWordsView alloc] initWithKeyWordArray:self.keyWords];
        [self.keyWordView showWithAnimation:NO inView:self.sideMenuController.view];
        self.canShowKeyWords = NO;
        self.keyWords = nil;
        [userDefaults setObject:[ZXTools getCurrentTimeWithFormat:@"yyyy-MM-dd"] forKey:@"keyWordDate"];
    }
}

- (HomeDateView *)dateView
{
    if (!_dateView) {
        _dateView = [[HomeDateView alloc] initWithFrame:CGRectMake(0, 0, 88, 40)];
        [self.view addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight + 5);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(88, 40));
        }];
    }
    return _dateView;
}

- (HomePageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[HomePageControl alloc] initWithTotalNumber:10];
        [self.view addSubview:_pageControl];
        
        CGFloat bottomDistance = 18;
        if (isiPhone_X) {
            bottomDistance += 34;
        }
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-bottomDistance);
        }];
    }
    return _pageControl;
}

- (void)hiddenDateAndPage
{
    if (!self.isHiddenDateAndPage) {
        self.isHiddenDateAndPage = YES;
        
        self.pageControl.hidden = YES;
        self.dateView.hidden = YES;
    }
}

- (void)showDateAndPage
{
    
    if (self.isHiddenDateAndPage) {
        self.isHiddenDateAndPage = NO;
        
        self.pageControl.hidden = NO;
        self.dateView.hidden = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [ZXTools postUMHandleWithContentId:@"news_share_home_start" key:nil value:nil];
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
