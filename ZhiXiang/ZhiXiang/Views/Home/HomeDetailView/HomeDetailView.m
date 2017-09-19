//
//  HomeDetailView.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeDetailView.h"
#import "HomeViewModel.h"
#import "SpecialTextCell.h"
#import "SpecialImageCell.h"
#import "SpecialTitleCell.h"
#import "SpecialArtCell.h"
#import "SpecialHeaderView.h"
#import "ZXTools.h"

CGFloat HomeDetailViewAnimationDuration = .4f;

@interface HomeDetailView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UITapGestureRecognizer * tap;

@property (nonatomic, assign) CGRect startFrame;

@property (nonatomic, strong) HomeViewModel * topModel; //数据源
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, assign) CGFloat HeaderHeight;

@end

@implementation HomeDetailView

- (instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)dataDic
{
    if (self = [super initWithFrame:frame]) {
        
        self.startFrame = frame;
        [self dealWithData:dataDic];
        [self createViews];
        
    }
    return self;
}

- (void)dealWithData:(NSDictionary *)dataDict{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    
    self.topModel = [[HomeViewModel alloc] init];
    self.topModel.name = [dataDict objectForKey:@"name"];
    self.topModel.title = [dataDict objectForKey:@"title"];
    self.topModel.img_url = [dataDict objectForKey:@"img_url"];
    self.topModel.desc = [dataDict objectForKey:@"desc"];
    self.topModel.imageURL = self.topModel.img_url;
    self.topModel.contentURL = [dataDict objectForKey:@"contentUrl"];
    self.topModel.shareType = 1;
    
    NSArray *resultArr = [dataDict objectForKey:@"list"];
    [self.dataSource removeAllObjects];
    for (int i = 0; i < resultArr.count; i ++) {
        HomeViewModel *tmpModel = [[HomeViewModel alloc] initWithDictionary:resultArr[i]];
        [self.dataSource addObject:tmpModel];
    }
}

-(void)setUpTableHeaderView{
    
    SpecialHeaderView *topView = [[SpecialHeaderView alloc] initWithFrame:CGRectZero];
    topView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    // 计算图片高度
    CGFloat imgHeight =kMainBoundsWidth *802.f/1242.f;//113
    CGFloat totalHeight = imgHeight + 25 + 40;// 25为下方留白 40为控件间隔
    // 计算描述文字内容的高度
    CGFloat descHeight = [ZXTools getAttrHeightByWidth:kMainBoundsWidth - 30 title:self.topModel.desc font:kPingFangLight(15)];
    totalHeight = totalHeight + descHeight;
    // 计算标题的高度
    CGFloat titleHeight = [ZXTools getHeightByWidth:kMainBoundsWidth - 30 title:self.topModel.title font:kPingFangMedium(22)];
    if (titleHeight > 31) {
        totalHeight = totalHeight + 62;
    }else{
        totalHeight = totalHeight + 31;
    }
    _HeaderHeight = totalHeight;
    
//    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, totalHeight)];
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, totalHeight);
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(totalHeight);
    }];
    [topView configModelData:self.topModel];
    
    self.tableView.tableHeaderView = self.headerView;
    
}
- (void)createViews
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 2)];
    [self addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor blueColor];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endScrrenToShow)];
    self.tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tap];
    self.tap.enabled = NO;
    
    [self createTableView];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeDetailCell"];
    [self addSubview:self.tableView];
//    self.tableView.tableHeaderView = self.headerView;
    [self setUpTableHeaderView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeDetailCell" forIndexPath:indexPath];
//    
//    cell.textLabel.text = @"测试一下这里的动画能不能正常进行";
//    cell.backgroundColor = [UIColor redColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
    
    
    HomeViewModel * model = [self.dataSource objectAtIndex:indexPath.row];
    // 1 文字  2 文章  3 图片  4 标题
    if (model.sgtype == 1){
        static NSString *cellID = @"SpecialTextCell";
        SpecialTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SpecialTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configWithText:model.stext];
        return cell;
        
    }else if (model.sgtype == 2){
        
        static NSString *cellID = @"SpecialArtCell";
        SpecialArtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SpecialArtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configModelData:model];
        
        return cell;
        
    }else if (model.sgtype == 3){
        static NSString *cellID = @"SpecialImgCell";
        SpecialImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SpecialImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configWithImageURL:model.img_url];
        
        return cell;
        
    }else if (model.sgtype == 4){
        static NSString *cellID = @"SpecialTitleCell";
        SpecialTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SpecialTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
        
        [cell configWithText:model.stitle];
        
        return cell;
        
    }else{
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
    
    return nil;
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
    
    if (model.sgtype == 3) {
        CGFloat imgHeight =  (kMainBoundsWidth - 15) *(802.f/1242.f);
        return  imgHeight + bottomBlank;
    }else if (model.sgtype == 2){
        CGFloat artHeight= 130 *802.f/1242.f + 10;
        return  artHeight + bottomBlank;
    }else if (model.sgtype == 1){
        CGFloat textHeight = [ZXTools getAttrHeightByWidth:kMainBoundsWidth - 30 title:model.stext font:kPingFangLight(15)];
        return  textHeight + bottomBlank;
    }else if (model.sgtype == 4){
        CGFloat titleHeight = [ZXTools getAttrHeightByWidthNoSpacing:kMainBoundsWidth - 30 title:model.stitle font:kPingFangLight(16)];
        return  titleHeight + bottomBlank;
    }
    return 22.5 + bottomBlank;
}

- (CGFloat)getBottomBlankWith:(HomeViewModel *)tmpModel nextModel:(HomeViewModel *)nextModel{
    // 1 文字  2 文章  3 图片  4 标题
    if (nextModel != nil) {
        if (tmpModel.sgtype == 1) {
            if (nextModel.sgtype == 1) {
                return 20;
            }else if (nextModel.sgtype == 2){
                return 25;
            }else if (nextModel.sgtype == 3){
                return 15;
            }else if (nextModel.sgtype == 4){
                return 25;
            }
        }else if (tmpModel.sgtype == 2){
            if (nextModel.sgtype == 1) {
                return 20;
            }else if (nextModel.sgtype == 2){
                return 5;
            }else if (nextModel.sgtype == 3){
                return 20;
            }else if (nextModel.sgtype == 4){
                return 25;
            }
        }else if (tmpModel.sgtype == 3){
            if (nextModel.sgtype == 1) {
                return 10;
            }else if (nextModel.sgtype == 2){
                return 20;
            }else if (nextModel.sgtype == 3){
                return 5;
            }else if (nextModel.sgtype == 4){
                return 25;
            }
        }else if (tmpModel.sgtype == 4){
            if (nextModel.sgtype == 1) {
                return 15;
            }else if (nextModel.sgtype == 2){
                return 20;
            }else if (nextModel.sgtype == 3){
                return 20;
            }else if (nextModel.sgtype == 4){
                return 25;
            }
        }
    }else{
        return 0.0;
    }
    return 0.0;
}

- (void)becomeScreenToRead
{
    CGFloat width = kMainBoundsWidth;
    CGFloat height = kMainBoundsHeight;
    [UIView animateWithDuration:HomeDetailViewAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.headerView.frame = CGRectMake(0, 0, width, _HeaderHeight);
        self.frame = CGRectMake(0, 0, width, height);
        self.tableView.frame = self.bounds;
    } completion:^(BOOL finished) {
        self.tap.enabled = YES;
//        [self.tableView reloadData];
    }];
}

- (void)endScrrenToShow
{
    self.tap.enabled = NO;
    CGFloat width = self.startFrame.size.width;
    CGFloat height = self.startFrame.size.height;
    [UIView animateWithDuration:HomeDetailViewAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = self.startFrame;
        self.headerView.frame = CGRectMake(0, 0, width, height / 2);
        self.tableView.frame = self.bounds;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
