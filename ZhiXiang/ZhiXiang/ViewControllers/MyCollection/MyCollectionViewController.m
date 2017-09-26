//
//  MyCollectionViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionRequest.h"
#import "RD_MJRefreshFooter.h"
#import "MyCollectionModel.h"
#import "ImageTextTableViewCell.h"
#import "ZXDetailArticleViewController.h"
#import "MBProgressHUD+Custom.h"


@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource, ZXDetailArticleViewControllerDelegate>

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
    
    [self.view setBackgroundColor:UIColorFromRGB(0xf8f6f1)];
    [self initInfo];
    
    [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    [self refreshData];
}

- (void)initInfo{
     self.title = @"收藏馆";
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

//下拉刷新页面数据
- (void)refreshData
{
    MyCollectionRequest * request = [[MyCollectionRequest alloc] initWithCollecTime:nil];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        NSDictionary *dic = (NSDictionary *)response;
        NSArray * dataArr = [dic objectForKey:@"result"];
        
        if (nil == dataArr || ![dataArr isKindOfClass:[NSArray class]] || dataArr.count == 0) {
            [self showNoDataViewInView:self.view noDataType:kNoDataType_Favorite];
            return;
        }
        
        [self.dataSource removeAllObjects];
        for (int i = 0; i < dataArr.count; i ++) {
            MyCollectionModel *welthModel = [[MyCollectionModel alloc] initWithDictionary:dataArr[i]];
            welthModel.type = 1;
            [self.dataSource addObject:welthModel];
        }
        
        [self.tableView reloadData];
        
        
        if (dataArr.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self showTopFreshLabelWithTitle:@"更新成功"];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (self.dataSource.count == 0) {
            [self showNoNetWorkView:NoNetWorkViewStyle_Load_Fail];
        }
        if (_tableView) {
            [self.tableView.mj_header endRefreshing];
            [self showTopFreshLabelWithTitle:@"数据出错了，更新失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (self.dataSource.count == 0) {
            [self showNoNetWorkView:NoNetWorkViewStyle_No_NetWork];
        }
        if (_tableView) {
            
            [self.tableView.mj_header endRefreshing];
            if (error.code == -1001) {
                [self showTopFreshLabelWithTitle:@"数据加载超时"];
            }else{
                [self showTopFreshLabelWithTitle:@"无法连接到网络，请检查网络设置"];
            }
        }
    }];
}

//上拉获取更多数据
- (void)getMoreData
{
    MyCollectionModel *tmpModel = [self.dataSource lastObject];
    MyCollectionRequest * request = [[MyCollectionRequest alloc] initWithCollecTime:tmpModel.collecTime];
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
        
        [self.tableView.mj_footer endRefrenshWithNoNetWork];
        
    }];
}

-(void)retryToGetData{
    [self hideNoNetWorkView];
    if (self.dataSource.count == 0)  {
        [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    }
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
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 7.5)];
        _tableView.tableHeaderView = headerView;
        
        //创建tableView动画加载头视图
        
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
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
    cell.backgroundColor = UIColorFromRGB(0xf8f6f1);
    
    [cell configModelData:model];
    
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat igTextHeight= 140 *802.f/1242.f;
    return igTextHeight + 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionModel *tmpModel = self.dataSource[indexPath.row];
    ZXDetailArticleViewController *daVC = [[ZXDetailArticleViewController alloc] initWithtopDailyID:tmpModel.dailyid];
    daVC.delegate = self;
    [self.navigationController presentViewController:daVC animated:YES completion:^{
        
    }];
}

- (void)ZXDetailarticleWillDismiss
{
    [self refreshData];
}

- (void)showSelfAndCreateLog
{
    if (_tableView) {
        NSArray * cells = self.tableView.visibleCells;
        for (UITableViewCell * cell in cells) {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//            MyCollectionModel * model = [self.dataSource objectAtIndex:indexPath.section];
//            [RDLogStatisticsAPI RDItemLogAction:RDLOGACTION_SHOW type:RDLOGTYPE_CONTENT model:model categoryID:[NSString stringWithFormat:@"%ld", self.categoryID]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
