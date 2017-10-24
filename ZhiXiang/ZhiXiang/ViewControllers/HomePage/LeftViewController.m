//
//  LeftViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftCacheCell.h"
#import "MyCollectionViewController.h"
#import "ZXAllArticleViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "ZXTools.h"
#import "UIImageView+WebCache.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RDAlertView.h"
#import "MBProgressHUD+Custom.h"
#import "GetDailyConfigRequest.h"
#import "UserLoginWayViewController.h"
#import "UserTelLoginViewController.h"
#import "leftMenuModel.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源

@property (nonatomic, strong) UIView * footView;

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation LeftViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZXUserDidLoginSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.view.backgroundColor = UIColorFromRGB(0x222222);
    [self initInfo];
    [self setUpTableHeaderView];
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoginStatus) name:ZXUserDidLoginSuccessNotification object:nil];
}

- (void)initInfo{
    
    leftMenuModel * model1 = [[leftMenuModel alloc] init];
    model1.title = @"我的收藏";
    model1.imageURL = @"wdshc";
    model1.type = MenuModelType_Collect;
    
    leftMenuModel * model2 = [[leftMenuModel alloc] init];
    model2.title = @"全部知享";
    model2.imageURL = @"qbzhx";
    model2.type = MenuModelType_All;
    
    self.dataSource = [NSMutableArray arrayWithArray:@[model1, model2]];
    [self.tableView reloadData];
    
    GetDailyConfigRequest * request = [[GetDailyConfigRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        if (dataDict && [dataDict isKindOfClass:[NSDictionary class]]) {
            
            NSInteger qingchu = [[dataDict objectForKey:@"state"] integerValue];
            NSInteger touping = [[dataDict objectForKey:@"touping"] integerValue];
            
            if (touping == 1) {
                leftMenuModel * model3 = [[leftMenuModel alloc] init];
                model3.title = @"投屏";
                model3.imageURL = @"qingchu";
                model3.type = MenuModelType_Screen;
                [self.dataSource addObject:model3];
            }
            
            if (qingchu == 1) {
                leftMenuModel * model4 = [[leftMenuModel alloc] init];
                model4.title = @"清除缓存";
                model4.imageURL = @"qingchu";
                model4.type = MenuModelType_Cache;
            }
            
            [self.tableView reloadData];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
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
        CGFloat width = kMainBoundsHeight > kMainBoundsWidth ? kMainBoundsWidth : kMainBoundsHeight;
        CGFloat scaleW = width / 375.f;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-60 * scaleW);
            make.right.mas_equalTo(0);
        }];

    }
    
    return _tableView;
}

-(void)setUpTableHeaderView{
    
    CGFloat height = kMainBoundsHeight > kMainBoundsWidth ? kMainBoundsHeight : kMainBoundsWidth;
    CGFloat scale = height / 667.f;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userViewDidBeClicked)];
    tap1.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userViewDidBeClicked)];
    tap2.numberOfTapsRequired = 1;
    
    UIView * iconBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    iconBGView.backgroundColor = UIColorFromRGB(0x404040);
    [topView addSubview:iconBGView];
    [iconBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(78);
        make.top.mas_equalTo(65 * scale);
        make.centerX.mas_equalTo(0);
    }];
    iconBGView.layer.cornerRadius = 39;
    iconBGView.clipsToBounds = YES;
    iconBGView.userInteractionEnabled = YES;
    [iconBGView addGestureRecognizer:tap1];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.backgroundColor = [UIColor clearColor];
    [iconBGView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(74);
        make.center.mas_equalTo(0);
    }];
    self.iconImageView.layer.cornerRadius = 37;
    self.iconImageView.clipsToBounds = YES;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = UIColorFromRGB(0x808080);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = kPingFangRegular(14);
    [topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tap2];
    
    [self refreshLoginStatus];
    
    CGFloat totalHeight = 65 * scale + 78 + 10 + 20 + 65 * scale;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, totalHeight)];
    [headView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(totalHeight);
    }];
    self.tableView.tableHeaderView = headView;
    
}

- (void)refreshLoginStatus
{
    if ([UserManager shareManager].isLoginWithWX) {
        self.nameLabel.text = [UserManager shareManager].wxUserName;
        
        CGFloat width = [ZXTools getWidthByHeight:15 title:self.nameLabel.text font:kPingFangRegular(14)];
        width += 10;
        if (width < 80) {
            width = 80;
        }
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager shareManager].wxIcon] placeholderImage:[UIImage imageNamed:@"wdl"]];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }else if([UserManager shareManager].isLoginWithTel){
        self.nameLabel.text = [UserManager shareManager].tel;
        CGFloat width = [ZXTools getWidthByHeight:15 title:self.nameLabel.text font:kPingFangRegular(14)];
        width += 10;
        if (width < 80) {
            width = 80;
        }
        
        self.iconImageView.image = [UIImage imageNamed:@"wdl"];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }else{
        self.nameLabel.text = @"点击登录";
        self.iconImageView.image = [UIImage imageNamed:@"wdl"];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
    }
}

- (void)userViewDidBeClicked
{
    if ([UserManager shareManager].isLoginWithWX || [UserManager shareManager].isLoginWithTel) {
        
        RDAlertView * alert = [[RDAlertView alloc] initWithTitle:@"" message:@"退出登录?"];
        RDAlertAction * action1 = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
            
        } bold:NO];
        RDAlertAction * action2 = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
            
            [[UserManager shareManager] canleLogin];
            [self refreshLoginStatus];
            
        } bold:YES];
        
        [alert addActions:@[action1, action2]];
        [alert show];
        
    }else{
        
        [self hideLeftViewAnimated:nil];
        if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            UserLoginWayViewController * loginWay = [[UserLoginWayViewController alloc] init];
            [(UINavigationController *)self.sideMenuController.rootViewController pushViewController:loginWay animated:NO];
        }else{
            UserTelLoginViewController * tel = [[UserTelLoginViewController alloc] init];
            [(UINavigationController *)self.sideMenuController.rootViewController pushViewController:tel animated:YES];
        }
    }
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectZero];
        _footView.backgroundColor = [UIColor clearColor];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorFromRGB(0x303030);
        [_footView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(.5f);
        }];
        
        UILabel * sloganLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sloganLabel.textAlignment = NSTextAlignmentLeft;
        sloganLabel.font = kPingFangRegular([ZXTools autoWidthWith:13]);
        sloganLabel.textColor = UIColorFromRGB(0x808080);
        sloganLabel.text = @"每天精选十条内容  高效·价值·品味";
        [_footView addSubview:sloganLabel];
        [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.bottom.right.mas_equalTo(0);
        }];
    }
    
    return _footView;
}

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
    static NSString *cellID = @"leftTableCell";
    static NSString *cacheCellID = @"leftCacheCell";
    
    leftMenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    if (model.type == MenuModelType_Cache) {
        LeftCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cacheCellID];
        if (cell == nil) {
            cell = [[LeftCacheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cacheCellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell hiddenLineView:YES];
        [cell configTitle:model.title andImage:model.imageURL];
        [cell setCacheSize:[self getApplicationCache]];
        
        return cell;
    }
    
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
       cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell hiddenLineView:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configTitle:model.title andImage:model.imageURL];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    leftMenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    if (model.type == MenuModelType_Collect) {
        [ZXTools postUMHandleWithContentId:@"news_share_menu_collect" key:nil value:nil];
        [self hideLeftViewAnimated:nil];
        MyCollectionViewController *mcVC = [[MyCollectionViewController alloc] init];
         [(UINavigationController *)self.sideMenuController.rootViewController pushViewController:mcVC  animated:NO];
    }else if (model.type == MenuModelType_All){
        [ZXTools postUMHandleWithContentId:@"news_share_menu_all" key:nil value:nil];
        [self hideLeftViewAnimated:nil];
        ZXAllArticleViewController *arVC = [[ZXAllArticleViewController alloc] init];
        [(UINavigationController *)self.sideMenuController.rootViewController pushViewController:arVC  animated:NO];
    }else if (model.type == MenuModelType_Cache){
        [self clearApplicationCache];
    }else if (model.type == MenuModelType_Screen){
        
    }
}

#pragma mark -- 获取当前系统的缓存大小
- (NSString *)getApplicationCache
{
    long long folderSize = 0;
    
    folderSize += [[SDImageCache sharedImageCache] getSize];
    
    if (folderSize > 1024 * 100) {
        return [NSString stringWithFormat:@"%.2lf M", folderSize/(1024.0*1024.0)];
    }else if(folderSize > 1024){
        return [NSString stringWithFormat:@"%.2lf KB", folderSize/1024.0];
    }else if (folderSize < 10){
        return [NSString stringWithFormat:@"%lld B", folderSize];
    }
    return [NSString stringWithFormat:@"%.2lld B", folderSize];
}

#pragma mark -- 清除当前系统缓存
- (void)clearApplicationCache
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在清除缓存" inView:[UIApplication sharedApplication].keyWindow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [[SDImageCache sharedImageCache] clearDisk];
        [MBProgressHUD showTextHUDWithText:@"清除成功" inView:[UIApplication sharedApplication].keyWindow];
        [self reloadCache];
    });
}

- (void)reloadCache
{
    if (self.dataSource.count >= 3) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [ZXTools postUMHandleWithContentId:@"news_share_menu" key:nil value:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [ZXTools postUMHandleWithContentId:@"news_share_menu_finish" key:nil value:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
