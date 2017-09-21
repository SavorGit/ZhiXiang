//
//  ZXAllArticleViewController.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXAllArticleViewController.h"
#import "AllArticelRequest.h"
#import "RD_MJRefreshHeader.h"
#import "RD_MJRefreshFooter.h"
#import "MJRefreshFooter.h"
#import "MyCollectionModel.h"
#import "ImageTextTableViewCell.h"
#import "ZXTools.h"
#import "ZXDetailArticleViewController.h"

@interface ZXAllArticleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, copy) NSString * cachePath;

@end

@implementation ZXAllArticleViewController

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
            [self.dataSource addObject:tmpModel];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self showLoadingView];
        [self refreshData];
    }
}

- (void)initInfo{
    self.title = @"知享库";
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

//下拉刷新页面数据
- (void)refreshData
{
    AllArticelRequest * request = [[AllArticelRequest alloc] initWithBespeakTime:nil];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        [self hiddenLoadingView];
        
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
        if (nil == dataDict || ![dataDict isKindOfClass:[NSDictionary class]] || dataDict.count == 0) {
            if (self.dataSource.count == 0) {
                [self showNoNetWorkView:NoNetWorkViewStyle_Load_Fail];
            }else{
                [self showTopFreshLabelWithTitle:@"数据出错了，更新失败"];
            }
            return;
        }
        
        NSArray *resultArr = [dataDict objectForKey:@"list"];
        
        [ZXTools saveFileOnPath:self.cachePath withArray:resultArr];
        [self.dataSource removeAllObjects];
        for (int i = 0; i < resultArr.count; i ++) {
            
            MyCollectionModel *tmpModel = [[MyCollectionModel alloc] initWithDictionary:resultArr[i]];
            [self.dataSource addObject:tmpModel];
        }
        
        [self.tableView reloadData];
        
        
        //每次返回20条
        if (resultArr.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self showTopFreshLabelWithTitle:@"更新成功"];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self hiddenLoadingView];
        if (self.dataSource.count == 0) {
            [self showNoNetWorkView:NoNetWorkViewStyle_Load_Fail];
        }
        if (_tableView) {
            [self.tableView.mj_header endRefreshing];
            [self showTopFreshLabelWithTitle:@"数据出错了，更新失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self hiddenLoadingView];
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
    AllArticelRequest * request = [[AllArticelRequest alloc] initWithBespeakTime:tmpModel.bespeak_time];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dic = (NSDictionary *)response;
        
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
        if (nil == dataDict || ![dataDict isKindOfClass:[NSDictionary class]] || dataDict.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        NSArray *resultArr = [dataDict objectForKey:@"list"];
        
        if (resultArr.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        //如果获取的数据数量不为0，则将数据添加至数据源，刷新当前列表
        for(NSDictionary *dict in resultArr){
            
            MyCollectionModel *tmpModel = [[MyCollectionModel alloc] initWithDictionary:dict];
            [self.dataSource addObject:tmpModel];
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
        [self showLoadingView];
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
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 7.5)];
        headerView.backgroundColor = UIColorFromRGB(0xf8f6f1);
        _tableView.tableHeaderView = headerView;
        
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
    cell.backgroundColor = UIColorFromRGB(0xf8f6f1);
    
    if (indexPath.row == self.dataSource.count - 1) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    
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
    
    ZXDetailArticleViewController *daVC = [[ZXDetailArticleViewController alloc] init];
    [self.navigationController pushViewController:daVC animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
