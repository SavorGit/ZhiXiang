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
#import "ZXKeyWordsView.h"
#import "HomeDetailView.h"
#import "HomeViewRequest.h"
#import "UIViewController+LGSideMenuController.h"
#import "HomeDateView.h"

@interface HomeViewController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSDictionary * detailDataDic; //数据源

@property (nonatomic, strong) NSMutableArray * dataSource; //数据源

@property (nonatomic, strong) HomeDateView * dateView;
@property (nonatomic, strong) HomeViewModel *dateModel; //日期数据源


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self dataRequest];
    [self setupNavigatinBar];
//    [self setupViews];

}

- (void)setupNavigatinBar
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLeftViewAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    
    [self dateView];
}

- (void)initInfor{
    _detailDataDic = [[NSDictionary alloc] init];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

- (void)setupViews
{
    self.view.backgroundColor = UIColorFromRGB(0x222222);
    
    self.pagerView = [[TYCyclePagerView alloc]init];
    self.pagerView.isInfiniteLoop = NO;
    self.pagerView.dataSource = self;
    self.pagerView.delegate = self;
    [self.pagerView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    [self.view addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-70);
        make.right.mas_equalTo(0);
    }];
    self.currentIndex = 0;
    
    [self.pagerView reloadData];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSArray * keyWords = @[@"iPhone X", @"孙宏斌", @"美联储", @"蒂芙尼珠宝", @"北海道肉蟹", @"贵族学校", @"百年普洱", @"小米", @"特朗普", @"蒂芙尼哈哈", @"法拉利的遗憾", @"品茶道人生"];
//        ZXKeyWordsView * keyWordView = [[ZXKeyWordsView alloc] initWithKeyWordArray:keyWords];
//        [keyWordView showWithAnimation:YES];
//    });
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
    HomeCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndex:index];
    [cell configModelData:tmpModel];
    return cell;
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
    if (index == self.currentIndex) {
        
        HomeViewModel *tmpModel = [self.dataSource objectAtIndex:index];
        CGRect detailViewFrame = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
        HomeDetailView * detailView = [[HomeDetailView alloc] initWithFrame:detailViewFrame andData:tmpModel];
        [[UIApplication sharedApplication].keyWindow addSubview:detailView];
        [detailView becomeScreenToRead];
        
        
    }else{
//        self.pagerView.userInteractionEnabled = NO;
//        [self.pagerView scrollToItemAtIndex:index animate:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.pagerView.userInteractionEnabled = YES;
//        });
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.currentIndex = toIndex;
}

- (void)dataRequest{
    
    HomeViewRequest * request = [[HomeViewRequest alloc] initWithIBespeakTime:nil];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        self.dateModel = [[HomeViewModel alloc] init];
        self.dateModel.day = [dataDict objectForKey:@"day"];
        self.dateModel.month = [dataDict objectForKey:@"month"];
        self.dateModel.week = [dataDict objectForKey:@"week"];
        
        NSArray *listArr = [dataDict objectForKey:@"list"];
        for (int i = 0; i < listArr.count; i ++) {
            NSDictionary *tmpDic = [listArr objectAtIndex:i];
            HomeViewModel *tmpModel = [[HomeViewModel alloc] initWithDictionary:tmpDic];
            tmpModel.detailDic = [tmpDic objectForKey:@"contentDetail"];
            [self.dataSource addObject:tmpModel];
            NSLog(@"%@",tmpDic);
        }
        
         [self setupViews];
         [self.dateView configWithModel:self.dateModel];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
    }];
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
