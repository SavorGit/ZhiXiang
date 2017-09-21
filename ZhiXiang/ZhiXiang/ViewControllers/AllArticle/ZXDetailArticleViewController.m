//
//  ZXDetailArticleViewController.m
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXDetailArticleViewController.h"
#import "HomeViewModel.h"
#import "HeaderTableViewCell.h"
#import "SpecialTextCell.h"
#import "SpecialImageCell.h"
#import "ZXTools.h"
#import "HomeDetailRequest.h"
#import "RD_MJRefreshHeader.h"
#import "RD_MJRefreshFooter.h"
#import "MJRefreshFooter.h"
#import "HomeViewModel.h"
#import "UIImageView+WebCache.h"

@interface ZXDetailArticleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, copy)   NSString * cachePath;

@property (nonatomic, strong) UIImageView * topView;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) HomeViewModel * topModel; //数据源
@property (nonatomic, copy)   NSString *dailyid;

@end

@implementation ZXDetailArticleViewController

- (instancetype)initWithtopDailyID:(NSString *)dailyid
{
    if (self = [super init]) {
        self.dailyid = dailyid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self dataRequest];
}

- (void)initInfo{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    self.cachePath = [NSString stringWithFormat:@"%@.plist",@"SpecialTopicGroup"];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];

//    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
//    self.navigationItem.rightBarButtonItem = shareItem;

}

- (void)dataRequest{
    
    HomeDetailRequest * request = [[HomeDetailRequest alloc] initWithDailyid:self.dailyid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        [self hiddenLoadingView];
        
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary * dataDict = [dic objectForKey:@"result"];
        
        [self.dataSource removeAllObjects];
        
        self.topModel = [[HomeViewModel alloc] init];
        self.topModel.is_collect = [dataDict objectForKey:@"is_collect"];
        self.topModel.title = [dataDict objectForKey:@"title"];
        self.topModel.sourceName = [dataDict objectForKey:@"sourceName"];
        self.topModel.imgUrl = [dataDict objectForKey:@"imgUrl"];
        self.topModel.imageURL = self.topModel.imgUrl;
        self.topModel.bespeak_time = [dataDict objectForKey:@"bespeak_time"];
        self.topModel.contentType = 1;
        [self.dataSource addObject:self.topModel];
        
        if (nil == dataDict || ![dataDict isKindOfClass:[NSDictionary class]] || dataDict.count == 0) {
            if (self.dataSource.count == 0) {
                [self showNoNetWorkView:NoNetWorkViewStyle_Load_Fail];
            }else{
                [self showTopFreshLabelWithTitle:@"数据出错了，更新失败"];
            }
            return;
        }
        
        NSArray *resultArr = [dataDict objectForKey:@"details"];
        
        [ZXTools saveFileOnPath:self.cachePath withArray:resultArr];
        for (int i = 0; i < resultArr.count; i ++) {
            HomeViewModel *tmpModel = [[HomeViewModel alloc] initWithDictionary:resultArr[i]];
            tmpModel.type = 1;
            [self.dataSource addObject:tmpModel];
        }
        
        [self setUpTableHeaderView];
        [self.tableView reloadData];
        [self.view insertSubview:self.topView aboveSubview:self.tableView ];
        
        
        if ([[dataDict objectForKey:@"nextpage"] integerValue] == 0) {
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
            make.top.mas_equalTo(- 20);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    return _tableView;
}

-(void)setUpTableHeaderView{
    
    float ImageHeight =  kMainBoundsWidth / 750.f * 488.f;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, ImageHeight)];
    topView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerImgView.frame = CGRectMake(0, 0, kMainBoundsWidth, ImageHeight);
    headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    headerImgView.layer.masksToBounds = YES;
    headerImgView.backgroundColor = [UIColor clearColor];
    [topView addSubview:headerImgView];
    [headerImgView sd_setImageWithURL:[NSURL URLWithString:self.topModel.imgUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
    self.tableView.tableHeaderView = topView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeViewModel * model = [self.dataSource objectAtIndex:indexPath.row];
    // 1 文字 3 图片
    if (model.contentType == 1) {
        static NSString *cellID = @"HeaderTableCell";
        HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[HeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configModelData:model];
        return cell;
    }
    if (model.dailytype == 1){
        static NSString *cellID = @"SpecialTextCell";
        SpecialTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SpecialTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configWithText:model.stext];
        return cell;
        
    }else if (model.dailytype == 3){
        static NSString *cellID = @"SpecialImgCell";
        SpecialImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SpecialImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configWithImageURL:model.spicture];
        
        return cell;
        
    }
     static NSString *cellID = @"defaultCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.backgroundColor = [UIColor clearColor];
     cell.contentView.backgroundColor = [UIColor clearColor];
    
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewModel * model = [self.dataSource objectAtIndex:indexPath.row];
    CGFloat bottomBlank;
    if (indexPath.row < self.dataSource.count - 1) {
        bottomBlank = [self getBottomBlankWith:model nextModel:[self.dataSource objectAtIndex:indexPath.row + 1]];
    }else{
        bottomBlank = [self getBottomBlankWith:model nextModel:nil];
    }
    if (model.contentType == 1) {
        CGFloat titleHeight = [ZXTools getHeightByWidth:kMainBoundsWidth - 30 title:model.title font:kPingFangMedium(22)];
        if (titleHeight > 31) {
            return  62 + 36  + 25;
        }else{
            return  31 + 36 + 25;
        }
    }else if (model.dailytype == 3) {
        CGFloat imgHeight =  (kMainBoundsWidth - 15) *(802.f/1242.f);
        return  imgHeight + bottomBlank;
    }else if (model.dailytype == 1){
        CGFloat textHeight = [ZXTools getAttrHeightByWidth:kMainBoundsWidth - 30 title:model.stext font:kPingFangLight(15)];
        return  textHeight + bottomBlank;
    }
    return 22.5 + bottomBlank;
}

- (CGFloat)getBottomBlankWith:(HomeViewModel *)tmpModel nextModel:(HomeViewModel *)nextModel{
    // 1 文字  3 图片
    if (nextModel != nil) {
        if (tmpModel.dailytype == 1) {
            if (nextModel.dailytype == 1) {
                return 20;
            }else if (nextModel.dailytype == 3){
                return 15;
            }
        }else if (tmpModel.dailytype == 3){
            if (nextModel.dailytype == 1) {
                return 10;
            }else if (nextModel.dailytype == 3){
                return 5;
            }
        }
    }else{
        return 0.0;
    }
    return 0.0;
}

- (UIView *)topView
{
    if (_topView == nil) {
        
        _topView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topView.userInteractionEnabled = YES;
        _topView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(64);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5,20, 40, 44)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_backButton];
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"icon_collect_yes"] forState:UIControlStateSelected];
        shareBtn.tag = 101;
        [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 44));
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(- 15);
        }];
        
        _collectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_collect_yes"] forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
        _collectBtn.tag = 102;
        [_topView addSubview:_collectBtn];
        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 44));
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(- 65);
        }];
    }
    return _topView;
}

- (void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
