//
//  LeftViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"
#import "MyCollectionViewController.h"
#import "ZXAllArticleViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * dataSource; //数据源
@property (nonatomic, strong) NSArray * imageData; //数据源

@property (nonatomic, strong) UIView * footView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.view.backgroundColor = UIColorFromRGB(0x222222);
    [self initInfo];
    [self.tableView reloadData];
    [self setUpTableHeaderView];
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];

    
}

- (void)initInfo{
    
    _dataSource = @[@"我的收藏",@"全部知享"];
    _imageData = @[@"wdshc", @"qbzhx"];
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

    }
    
    return _tableView;
}

-(void)setUpTableHeaderView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.image = [UIImage imageNamed:@"cd_logo"];
    iconImgView.backgroundColor = [UIColor clearColor];
    [topView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(77);
        make.top.mas_equalTo(70);
        make.centerX.mas_equalTo(topView);
    }];
    
    CGFloat totalHeight = 232;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, totalHeight)];
    [headView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(totalHeight);
    }];
    self.tableView.tableHeaderView = headView;
    
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectZero];
        _footView.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = [UIImage imageNamed:@"cd_slogan"];
        iconImgView.backgroundColor = [UIColor clearColor];
        [_footView addSubview:iconImgView];
        [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(192);
            make.height.mas_equalTo(14);
            make.bottom.mas_equalTo(- 60);
            make.centerX.mas_equalTo(_footView);
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
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
       cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configTitle:self.dataSource[indexPath.row] andImage:self.imageData[indexPath.row]];
    
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self hideLeftViewAnimated:nil];
        MyCollectionViewController *mcVC = [[MyCollectionViewController alloc] init];
         [(UINavigationController *)self.sideMenuController.rootViewController pushViewController:mcVC  animated:NO];
    }else if (indexPath.row == 1){
        [self hideLeftViewAnimated:nil];
        ZXAllArticleViewController *arVC = [[ZXAllArticleViewController alloc] init];
        [(UINavigationController *)self.sideMenuController.rootViewController pushViewController:arVC  animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
