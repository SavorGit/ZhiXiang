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
#import "HeaderTableViewCell.h"
#import "SpecialHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ZXTools.h"
#import "IsCollectionRequest.h"
#import "ZXIsOrCollectionRequest.h"
#import "MBProgressHUD+Custom.h"
#import "UMCustomSocialManager.h"
#import "ShareBoardView.h"

CGFloat HomeDetailViewShowAnimationDuration = .4f;
CGFloat HomeDetailViewHiddenAnimationDuration = .3f;

@interface HomeDetailView () <UITableViewDelegate, UITableViewDataSource>

//minStyle
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) UIView * bottoView;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel * titleLabel;

//maxStyle
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) HomeViewModel * topModel; //数据源
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源

@property (nonatomic, strong) SpecialHeaderView *topView;

@property (nonatomic, assign) CGRect startFrame;
@property (nonatomic, assign) CGFloat HeaderHeight;

@property (nonatomic, strong) UIImageView * blackView;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isCheckCollectting;

@property (nonatomic, weak) UIViewController * VC;

@end

@implementation HomeDetailView

- (instancetype)initWithFrame:(CGRect)frame andData:(HomeViewModel *)model andVC:(UIViewController *)VC
{
    if (self = [super initWithFrame:frame]) {
        
        self.VC = VC;
        self.clipsToBounds = YES;
        self.startFrame = frame;
        [self dealWithData:model];
        [self createViews];
        self.layer.cornerRadius = 10.f;
        
    }
    return self;
}

- (void)dealWithData:(HomeViewModel *)model{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    
    NSDictionary *tmpDic = model.detailDic;
    self.topModel = [[HomeViewModel alloc] init];
    self.topModel.sourceName = [tmpDic objectForKey:@"sourceName"];
    self.topModel.title = [tmpDic objectForKey:@"title"];
    self.topModel.imgUrl = [tmpDic objectForKey:@"imgUrl"];
    self.topModel.bespeak_time = [tmpDic objectForKey:@"bespeak_time"];
    self.topModel.share_url = [tmpDic objectForKey:@"share_url"];
    self.topModel.desc = model.desc;
    self.topModel.contentType = 1;
    self.topModel.dailyid = model.dailyid;
    [self.dataSource addObject:self.topModel];
    
    NSArray *resultArr = [tmpDic objectForKey:@"details"];
    for (int i = 0; i < resultArr.count; i ++) {
        HomeViewModel *tmpModel = [[HomeViewModel alloc] initWithDictionary:resultArr[i]];
        [self.dataSource addObject:tmpModel];
    }
}

-(void)setUpTableHeaderView{
    
    self.topView = [[SpecialHeaderView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    [self.topView configModelData:self.topModel];
    
    self.tableView.tableHeaderView = self.topView;
    
}
- (void)createViews
{
    self.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    [self setUpMaxStyle];
    [self setUpMinStyle];
    [self checkIsCollection];
}

- (void)checkIsCollection
{
    self.isCheckCollectting = YES;
    IsCollectionRequest * request = [[IsCollectionRequest alloc] initWithDailyid:self.topModel.dailyid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        BOOL isCollected = [[dataDict objectForKey:@"state"] boolValue];
        
        self.collectBtn.selected = isCollected;
        
        self.isCheckCollectting = NO;
        [self.collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
        [self autoCollectButton];
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.isCheckCollectting = NO;
        [self.collectBtn addTarget:self action:@selector(retryToGetIsCollection) forControlEvents:UIControlEventTouchUpInside];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        self.isCheckCollectting = NO;
        [self.collectBtn addTarget:self action:@selector(retryToGetIsCollection) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
}

- (void)collectAction
{
    if (self.isCheckCollectting) {
        [MBProgressHUD showTextHUDWithText:@"正在获取收藏状态" inView:self];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self];
    ZXIsOrCollectionRequest * request = [[ZXIsOrCollectionRequest alloc] initWithDailyid:self.topModel.dailyid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        self.collectBtn.selected = !self.collectBtn.isSelected;
        if (self.collectBtn.isSelected) {
            [MBProgressHUD showSuccessWithText:@"收藏成功" inView:self];
        }else{
            [MBProgressHUD showSuccessWithText:@"取消成功" inView:self];
        }
        [self autoCollectButton];
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"操作失败" inView:self];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"操作失败" inView:self];
        
    }];
}

- (void)autoCollectButton
{
    if (self.collectBtn.isSelected) {
        [self.collectBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateHighlighted];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateHighlighted];
    }
}

- (void)retryToGetIsCollection
{
    [MBProgressHUD showTextHUDWithText:@"正在获取收藏状态" inView:self];
    [self checkIsCollection];
}

- (void)setUpMinStyle
{
    CGFloat topHeight = self.bounds.size.width / 750.f * 488.f;
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topHeight)];
    self.topImageView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.layer.masksToBounds = YES;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:self.topModel.imgUrl]];
    
    self.bottoView = [[UIView alloc] initWithFrame:CGRectMake(0, topHeight, self.bounds.size.width, self.bounds.size.height - topHeight)];
    [self addSubview:self.bottoView];
    self.bottoView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.baseView = [[UIView alloc] initWithFrame:self.bottoView.bounds];
    [self.bottoView addSubview:self.baseView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, self.bottoView.frame.size.width - 30, 20)];
    self.titleLabel.text = self.topModel.title;
    self.titleLabel.textColor = UIColorFromRGB(0x222222);
    self.titleLabel.font = kPingFangMedium(19);
    self.titleLabel.numberOfLines = 2;
    [self.baseView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + 20 + 15, self.bottoView.frame.size.width - 30, self.bottoView.frame.size.height - 60)];
    self.subTitleLabel.text = self.topModel.desc;
    self.subTitleLabel.font = kPingFangLight(15);
    self.subTitleLabel.textColor = UIColorFromRGB(0x575757);
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.numberOfLines = 0;
    [self.baseView addSubview:self.subTitleLabel];
    [self configSubTitleWithWidth:self.bottoView.frame.size.width - 30];
    
    if (!isEmptyString(self.topModel.sourceName)) {
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.bottoView.frame.size.height - 30, self.bottoView.frame.size.width - 30, 15)];
        self.fromLabel.text = [@"选自: " stringByAppendingString:self.topModel.sourceName];
        self.fromLabel.textAlignment = NSTextAlignmentRight;
        self.fromLabel.textColor = UIColorFromRGB(0x999999);
        self.fromLabel.font = kPingFangRegular(12);
        [self.baseView addSubview:self.fromLabel];
    }
}

- (void)configSubTitleWithWidth:(CGFloat)width
{
    CGFloat titleHeight = [ZXTools getHeightByWidth:self.bounds.size.width - 30 title:self.titleLabel.text font:kPingFangMedium(19)];
    if (titleHeight > 32) {
        self.titleLabel.frame = CGRectMake(15, 25, self.bottoView.frame.size.width - 30, 54);
    }else{
        self.titleLabel.frame = CGRectMake(15, 25, self.bottoView.frame.size.width - 30, 20);
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.subTitleLabel.text];
    NSUInteger length = [self.subTitleLabel.text length];
    [attrString addAttribute:NSFontAttributeName value:kPingFangLight(15) range:NSMakeRange(0, length)];//设置所有的字体
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    self.subTitleLabel.attributedText = attrString;
    
    // 计算富文本的高度
    CGFloat descHeight = [self.subTitleLabel sizeThatFits:self.subTitleLabel.bounds.size].height;
    
    CGFloat bottomHight = self.bottoView.bounds.size.height;
    
    CGFloat subTitleHeight;
    if (titleHeight > 32) {
        subTitleHeight = bottomHight - 25 - 15 - 54 - 15 - 15 - 10;
    }else{
        subTitleHeight = bottomHight - 25 - 15 - 20 - 15 - 15 - 10;
    }
    
    CGFloat startY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 15;
    if (descHeight >= subTitleHeight) {
        self.subTitleLabel.frame = CGRectMake(15, startY, width, subTitleHeight);
    }else{
        self.subTitleLabel.frame = CGRectMake(15, startY, width, descHeight + 10.f);
    }
}

- (void)setUpMaxStyle
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeDetailCell"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self addSubview:self.tableView];
    [self setUpTableHeaderView];
    self.tableView.alpha = 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeViewModel * model = [self.dataSource objectAtIndex:indexPath.row];
    // 1 文字  3 图片 
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
    if (model.contentType == 1) {
        CGFloat titleHeight = [ZXTools getHeightByWidth:kMainBoundsWidth - 30 title:model.title font:kPingFangMedium(19)];
        if (titleHeight > 27) {
            return  54 + 30  + 25;
        }else{
            return  27 + 30 + 25;
        }
    }else if (model.dailytype == 3) {
        CGFloat imgHeight =  (kMainBoundsWidth - 40) *(802.f/1242.f);
        return  imgHeight + bottomBlank;
    }else if (model.dailytype == 1){
        CGFloat textHeight = [ZXTools getAttrHeightByWidth:kMainBoundsWidth - 40 title:model.stext font:kPingFangLight(16)];
        return  textHeight + bottomBlank;
    }
    return 22.5 + bottomBlank;
}

- (CGFloat)getBottomBlankWith:(HomeViewModel *)tmpModel nextModel:(HomeViewModel *)nextModel{
    // 1 文字  3 图片
    if (nextModel != nil) {
        if (tmpModel.dailytype == 1) {
            if (nextModel.dailytype == 1) {
                return 30;//标注40间距过大
            }else if (nextModel.dailytype == 3){
                return 15;
            }
        }else if (tmpModel.dailytype == 3){
            if (nextModel.dailytype == 1) {
                return 30;
            }else if (nextModel.dailytype == 3){
                return 15;
            }
        }
    }else{
        return 0.0;
    }
    return 0.0;
}

- (void)becomeScreenToReadCompelete:(void (^)())compelete
{
    self.tableView.frame = CGRectMake(-self.startFrame.origin.x, -self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
    
    [self addSubview:self.topImageView];
    [UIView animateWithDuration:HomeDetailViewShowAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
        self.tableView.frame = self.bounds;
        [self.topView startScrShow];
        self.topImageView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 750.f * 488.f);
        
        self.bottoView.frame = CGRectMake(0, kMainBoundsWidth / 750.f * 488.f, kMainBoundsWidth, kMainBoundsHeight - kMainBoundsWidth / 750.f * 488.f);
        
        CGRect frame = self.baseView.bounds;
        self.baseView.frame = CGRectMake((kMainBoundsWidth - frame.size.width) / 2, (kMainBoundsHeight - self.topImageView.frame.size.height) / 2, frame.size.width, frame.size.height);
        
    } completion:^(BOOL finished) {
        [self.topImageView removeFromSuperview];
        self.layer.cornerRadius = 0.f;
        
        [self addSubview:self.blackView];
        self.blackView.alpha = .2f;
        [UIView animateWithDuration:.2f animations:^{
            self.blackView.alpha = 1.f;
        }];
    }];
    self.tableView.tableHeaderView = self.topView;
    
    [UIView animateWithDuration:HomeDetailViewShowAnimationDuration / 2 animations:^{
        self.bottoView.alpha = .2f;
        self.tableView.alpha = .2f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:HomeDetailViewShowAnimationDuration / 2 animations:^{
            self.bottoView.alpha = 0;
            self.tableView.alpha = 1;
            if (compelete) {
                compelete();
            }
        }];
    }];
}

- (void)endScrrenToShow
{
    [self.blackView removeFromSuperview];
    [self addSubview:self.topImageView];
    self.layer.cornerRadius = 10.f;
    
    [UIView animateWithDuration:HomeDetailViewHiddenAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = self.startFrame;
         [self.topView endScrShow];
        self.topImageView.frame = CGRectMake(0, 0, self.startFrame.size.width, self.startFrame.size.width / 750.f * 488.f);
        self.tableView.frame = CGRectMake(-self.startFrame.origin.x, -self.startFrame.origin.y, kMainBoundsWidth, kMainBoundsHeight);
        self.bottoView.frame = CGRectMake(0, self.topImageView.frame.size.height, self.startFrame.size.width, self.startFrame.size.height - self.topImageView.frame.size.height);
        
        self.baseView.frame = self.bottoView.bounds;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.topImageView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:HomeDetailViewHiddenAnimationDuration / 2 animations:^{
        self.tableView.alpha = .2f;
        self.bottoView.alpha = .5f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:HomeDetailViewHiddenAnimationDuration / 2 animations:^{
            self.tableView.alpha = 0;
            self.bottoView.alpha = 1;
        }];
    }];
}

- (UIImageView *)blackView
{
    if (_blackView == nil) {
        
        _blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44 + kStatusBarHeight)];
        _blackView.userInteractionEnabled = YES;
        _blackView.contentMode = UIViewContentModeScaleToFill;
        [_blackView setImage:[UIImage imageNamed:@"quanpingmc"]];
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5,kStatusBarHeight, 40, 44)];
        [_backButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_blackView addSubview:_backButton];
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateSelected];
        shareBtn.tag = 101;
        [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [_blackView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 44));
            make.top.mas_equalTo(kStatusBarHeight);
            make.right.mas_equalTo(- 15);
        }];
        
        [_blackView addSubview:self.collectBtn];
        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 44));
            make.top.mas_equalTo(kStatusBarHeight);
            make.right.mas_equalTo(- 65);
        }];
    }
    return _blackView;
}

- (void)shareAction{
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
        
        ShareBoardView *shareView = [[ShareBoardView alloc] initWithFrame:CGRectZero Model:nil andVC:self.VC];
        shareView.backgroundColor = [UIColor clearColor];
    }else{
        [MBProgressHUD showTextHUDWithText:@"请安装微信后使用" inView:self];
    }
}

-(UIButton *)collectBtn
{
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_collectBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _collectBtn;
}

- (void)backButtonClick
{
    [self endScrrenToShow];
}

@end
