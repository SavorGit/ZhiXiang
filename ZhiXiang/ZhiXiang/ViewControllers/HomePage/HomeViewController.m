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
#import "LeftViewController.h"
#import "HomeGuideCollectionViewCell.h"
#import "HomeCommandCollectionViewCell.h"

@interface HomeViewController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, HomeStatusCellDelegate>
{
    NSTimer *_timer;
    NSTimer *_timerTwo;
    NSTimer *_timerThree;
    
    int aa;
    __block UIBackgroundTaskIdentifier _backIden;
    __block UIBackgroundTaskIdentifier _backIdenTwo;
}

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

@property (nonatomic, assign) BOOL isHiddenDate;
@property (nonatomic, assign) BOOL isHiddenPage;
@property (nonatomic, assign) BOOL isUserClickCell;

@property (nonatomic, copy) NSString * keyWordDate;

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
        make.top.mas_equalTo(kStatusBarHeight + 5);
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
        
        LeftViewController * left = (LeftViewController *)LGSide.leftViewController;
        [left reloadCache];
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
    [self.pagerView registerClass:[HomeCommandCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCommandCollectionViewCell"];
    [self.pagerView registerClass:[HomeGuideCollectionViewCell class] forCellWithReuseIdentifier:@"HomeGuideCollectionViewCell"];
    
    [self.view addSubview:self.pagerView];
    
    CGFloat bottomDistance = 77;
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
    
    if (index >= self.dataSource.count) {
        HomeStatusCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeStatusCollectionViewCell" forIndex:index];
        self.statusCell = cell;
        self.statusCell.delegate = self;
        if (self.isRequest) {
            [self.statusCell showLoading];
        }
        
        return cell;
    }
    
    HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
    if (tmpModel.modelType == HomeViewModelType_Command) {
        HomeCommandCollectionViewCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeCommandCollectionViewCell" forIndex:index];
        cell.backgroundColor = [UIColor whiteColor];
        cell.VC = self.navigationController;
        return cell;
    }else if (tmpModel.modelType == HomeViewModelType_PageGuide) {
        HomeGuideCollectionViewCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeGuideCollectionViewCell" forIndex:index];
        [cell configWithModel:tmpModel];
        return cell;
    }
    
    HomeCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndex:index];
    [cell configModelData:tmpModel];
    return cell;
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
    [self hiddenDateAndPage];
    
    if (self.isRequest || self.isNoMoreData || self.dataSource.count == 0) {
        return;
    }
    
    self.isRequest = YES;
    if (self.statusCell) {
        [self.statusCell showLoading];
    }
    
    NSInteger totalIndex = self.dataSource.count;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HomeViewModel *tmpModel = [self.dataSource lastObject];
        HomeViewRequest * request = [[HomeViewRequest alloc] initWithIBespeakTime:tmpModel.bespeak_time];
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
                tmpModel.bespeak_time = [tmpModel.detailDic objectForKey:@"bespeak_time"];
                tmpModel.modelType = HomeViewModelType_Default;
                
                [self.dataSource addObject:tmpModel];
                
                if (i == 0) {
                    [self.dateView configWithModel:tmpModel];
                }
                
            }
            
            HomeViewModel * model = [self.dataSource lastObject];
            
            HomeViewModel * guideModel = [[HomeViewModel alloc] init];
            guideModel.modelType = HomeViewModelType_PageGuide;
            guideModel.bespeak_time = model.bespeak_time;
            guideModel.dailyart = [dataDict objectForKey:@"dailyart"];
            guideModel.dailyauthor = [dataDict objectForKey:@"dailyauthor"];
            guideModel.day = model.day;
            guideModel.week = model.week;
            guideModel.month = model.month;
            
            if ([dataDict objectForKey:@"nextpage"]) {
                NSDictionary * nextPageDict = [dataDict objectForKey:@"nextpage"];
                NSInteger next = [[nextPageDict objectForKey:@"next"] integerValue];
                if (next == 0) {
                    guideModel.contentType = 3;
                }else{
                    guideModel.contentType = 2;
                    guideModel.nextMonth = [nextPageDict objectForKey:@"month"];
                    guideModel.nextDay = [nextPageDict objectForKey:@"day"];
                    guideModel.nextWeek = [nextPageDict objectForKey:@"week"];
                }
            }
            
            [self.dataSource addObject:guideModel];
            
            if (self.currentIndex >= totalIndex) {
                if (self.currentIndex >= 12) {
                    [self.pageControl setCurrentIndex:(self.currentIndex - 1) % 11 + 1];
                }else{
                    [self.pageControl setCurrentIndex:self.currentIndex % 11 + 1];
                }
                [self showDateAndPage];
            }
            
            [self.pagerView reloadData];
            self.isRequest = NO;
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
        layout.itemSize = CGSizeMake(kMainBoundsWidth - 60, kMainBoundsHeight - kStatusBarHeight - 70 - 77 - 34);
    }else{
        layout.itemSize = CGSizeMake(kMainBoundsWidth - 60, kMainBoundsHeight - kStatusBarHeight - 70 - 77);
    }
    layout.itemSpacing = 18;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (index < self.dataSource.count && index == self.currentIndex) {
        HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
        
        if (tmpModel.modelType == HomeViewModelType_Default) {
            pageView.userInteractionEnabled = NO;
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
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [ZXTools postUMHandleWithContentId:@"news_share_home_card_slide" key:nil value:nil];
    self.currentIndex = toIndex;
    if (toIndex < self.dataSource.count) {
        HomeViewModel * model = [self.dataSource objectAtIndex:toIndex];
        [self.dateView configWithModel:model];
        if (model.modelType == HomeViewModelType_Default) {
            [self showDateAndPage];
            
            if (toIndex >= 12) {
                [self.pageControl setCurrentIndex:(toIndex - 1) % 11 + 1];
            }else{
                [self.pageControl setCurrentIndex:toIndex % 11 + 1];
            }
            
        }else{
            [self onlyHiddenPage];
        }
    }else {
        [self startLoadMoreData];
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
            tmpModel.bespeak_time = [tmpModel.detailDic objectForKey:@"bespeak_time"];
            tmpModel.modelType = HomeViewModelType_Default;
            
            if (i == 0) {
                [self.dateView configWithModel:tmpModel];
            }
        }
        
        HomeViewModel * model = [self.dataSource lastObject];
        
        HomeViewModel * commandModel = [[HomeViewModel alloc] init];
        commandModel.modelType = HomeViewModelType_Command;
        commandModel.bespeak_time = model.bespeak_time;
        commandModel.day = model.day;
        commandModel.week = model.week;
        commandModel.month = model.month;
        [self.dataSource addObject:commandModel];
        
        HomeViewModel * guideModel = [[HomeViewModel alloc] init];
        guideModel.modelType = HomeViewModelType_PageGuide;
        guideModel.dailyart = [dataDict objectForKey:@"dailyart"];
        guideModel.dailyauthor = [dataDict objectForKey:@"dailyauthor"];
        guideModel.bespeak_time = model.bespeak_time;
        guideModel.day = model.day;
        guideModel.week = model.week;
        guideModel.month = model.month;
        
        if ([[dataDict objectForKey:@"is_same_day"] integerValue] == 0) {
            
            if ([dataDict objectForKey:@"nextpage"]) {
                NSDictionary * nextPageDict = [dataDict objectForKey:@"nextpage"];
                NSInteger next = [[nextPageDict objectForKey:@"next"] integerValue];
                if (next == 0) {
                    guideModel.contentType = 3;
                }else{
                    guideModel.contentType = 2;
                    guideModel.nextMonth = [nextPageDict objectForKey:@"month"];
                    guideModel.nextDay = [nextPageDict objectForKey:@"day"];
                    guideModel.nextWeek = [nextPageDict objectForKey:@"week"];
                }
            }
        }
        
        [self.dataSource addObject:guideModel];
        
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

        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSArray * list = [dataDict objectForKey:@"list"];
        if (list && [list isKindOfClass:[NSArray class]]) {

            self.keyWords = [NSArray arrayWithArray:list];
            self.keyWordDate = [dataDict objectForKey:@"put_time"];
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
        if ([self.keyWordDate isEqualToString:date]) {
            return;
        }
    }
    
    if (self.keyWords && self.keyWords.count > 0) {
        [ZXTools postUMHandleWithContentId:@"news_share_key_words_show" key:nil value:nil];
        self.keyWordView = [[ZXKeyWordsView alloc] initWithKeyWordArray:self.keyWords];
        [self.keyWordView showWithAnimation:YES inView:self.sideMenuController.view];
        self.canShowKeyWords = NO;
        self.keyWords = nil;
        [userDefaults setObject:self.keyWordDate forKey:@"keyWordDate"];
    }
}

- (HomeDateView *)dateView
{
    if (!_dateView) {
        _dateView = [[HomeDateView alloc] initWithFrame:CGRectMake(0, 0, 88, 40)];
        [self.view addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight + 10);
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
        
        CGFloat bottomDistance = 11;
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

- (void)onlyHiddenPage
{
    self.pageControl.hidden = YES;
    self.isHiddenPage = YES;
    self.dateView.hidden = NO;
    self.isHiddenDate = NO;
}

- (void)hiddenDateAndPage
{
    if (!self.isHiddenDate) {
        self.isHiddenDate = YES;
        self.dateView.hidden = YES;
    }
    if (!self.isHiddenPage) {
        self.pageControl.hidden = YES;
        self.isHiddenPage = YES;
    }
}

- (void)showDateAndPage
{
    if (self.isHiddenDate) {
        self.isHiddenDate = NO;
        self.dateView.hidden = NO;
    }
    if (self.isHiddenPage) {
        self.isHiddenPage = NO;
        self.pageControl.hidden = NO;
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
