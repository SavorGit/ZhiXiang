//
//  MyCollectionViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionRequest.h"
#import "RD_MJRefreshHeader.h"
#import "RD_MJRefreshFooter.h"
#import "MyCollectionModel.h"
#import "ImageTextTableViewCell.h"


@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, copy) NSString * cachePath;

@end

@implementation MyCollectionViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.categoryID = 101;
        self.cachePath = [NSString stringWithFormat:@"%ld.plist", self.categoryID];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VCBackgroundColor];
    [self initInfo];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cachePath]) {
        
        //如果本地缓存的有数据，则先从本地读取缓存的数据
        NSArray * dataArr = [NSArray arrayWithContentsOfFile:self.cachePath];
        for(NSDictionary *dict in dataArr){
            MyCollectionModel *tmpModel = [[MyCollectionModel alloc] initWithDictionary:dict];
            tmpModel.type = 1;
            [self.dataSource addObject:tmpModel];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header beginRefreshing];
    }else{
//        [self showLoadingView];
        [self refreshData];
    }
}

- (void)initInfo{
     self.title = @"我的收藏";
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

//下拉刷新页面数据
- (void)refreshData
{
    MyCollectionRequest * request = [[MyCollectionRequest alloc] initWithCateId:self.categoryID withSortNum:nil];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
//        [self hiddenLoadingView];
        
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
//        if (nil == dataDict || ![dataDict isKindOfClass:[NSDictionary class]] || dataDict.count == 0) {
//            if (self.dataSource.count == 0) {
//                [self showNoNetWorkView:NoNetWorkViewStyle_Load_Fail];
//            }else{
//                [self showTopFreshLabelWithTitle:RDLocalizedString(@"RDString_NetFailedWithData")];
//            }
//            return;
//        }
        
        NSArray *resultArr = [dataDict objectForKey:@"list"];
        
//        [SAVORXAPI saveFileOnPath:self.cachePath withArray:resultArr];
        [self.dataSource removeAllObjects];
        for (int i = 0; i < resultArr.count; i ++) {
            MyCollectionModel *welthModel = [[MyCollectionModel alloc] initWithDictionary:resultArr[i]];
            welthModel.type = 1;
            [self.dataSource addObject:welthModel];
        }
        
        [self.tableView reloadData];
        
        
        if ([[dataDict objectForKey:@"nextpage"] integerValue] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        
//        [self showTopFreshLabelWithTitle:RDLocalizedString(@"RDString_SuccessWithUpdate")];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
//        [self hiddenLoadingView];
//        if (self.dataSource.count == 0) {
//            [self showNoNetWorkView:NoNetWorkViewStyle_Load_Fail];
//        }
//        if (_tableView) {
//            [self.tableView.mj_header endRefreshing];
//            [self showTopFreshLabelWithTitle:RDLocalizedString(@"RDString_NetFailedWithData")];
//        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
//        [self hiddenLoadingView];
//        if (self.dataSource.count == 0) {
//            [self showNoNetWorkView:NoNetWorkViewStyle_No_NetWork];
//        }
//        if (_tableView) {
//            
//            [self.tableView.mj_header endRefreshing];
//            if (error.code == -1001) {
//                [self showTopFreshLabelWithTitle:RDLocalizedString(@"RDString_NetFailedWithTimeOut")];
//            }else{
//                [self showTopFreshLabelWithTitle:RDLocalizedString(@"RDString_NetFailedWithBadNet")];
//            }
//        }
    }];
}

//上拉获取更多数据
- (void)getMoreData
{
    MyCollectionModel *welthModel = [self.dataSource lastObject];
    MyCollectionRequest * request = [[MyCollectionRequest alloc] initWithCateId:self.categoryID withSortNum:welthModel.sort_num];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dic = (NSDictionary *)response;
        
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
        if (nil == dataDict || ![dataDict isKindOfClass:[NSDictionary class]] || dataDict.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        NSArray *resultArr = [dataDict objectForKey:@"list"];
        
        if ([[dataDict objectForKey:@"nextpage"] integerValue] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        //如果获取的数据数量不为0，则将数据添加至数据源，刷新当前列表
        for(NSDictionary *dict in resultArr){
            MyCollectionModel *welthModel = [[MyCollectionModel alloc] initWithDictionary:dict];
            [self.dataSource addObject:welthModel];
        }
        [self.tableView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_footer endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
//        [self.tableView.mj_footer endRefrenshWithNoNetWork];
        
    }];
}

-(void)retryToGetData{
//    [self hideNoNetWorkView];
//    if (self.dataSource.count == 0)  {
//        [self showLoadingView];
//    }
    [self refreshData];
}

#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xece6de);
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        //创建tableView动画加载头视图
        
        _tableView.mj_header = [RD_MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        RD_MJRefreshFooter* footer = [RD_MJRefreshFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
        _tableView.mj_footer = footer;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionModel * model = [self.dataSource objectAtIndex:indexPath.row];
    static NSString *cellID = @"imageTextTableCell";
    ImageTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ImageTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    [cell configModelData:model];
    
    return cell;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat igTextHeight= 130 *802.f/1242.f;
    return igTextHeight + 12;
}

- (void)showSelfAndCreateLog
{
    if (_tableView) {
        NSArray * cells = self.tableView.visibleCells;
        for (UITableViewCell * cell in cells) {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            MyCollectionModel * model = [self.dataSource objectAtIndex:indexPath.section];
//            [RDLogStatisticsAPI RDItemLogAction:RDLOGACTION_SHOW type:RDLOGTYPE_CONTENT model:model categoryID:[NSString stringWithFormat:@"%ld", self.categoryID]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end