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
#import "HeaderTableViewCell.h"
#import "SpecialHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ZXTools.h"

CGFloat HomeDetailViewShowAnimationDuration = .4f;
CGFloat HomeDetailViewHiddenAnimationDuration = .4f;

@interface HomeDetailView () <UITableViewDelegate, UITableViewDataSource>

//minStyle
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) UIView * bottoView;
@property (nonatomic, strong) UILabel *subTitleLabel;

//maxStyle
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) HomeViewModel * topModel; //数据源
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源

@property (nonatomic, strong) SpecialHeaderView *topView;

@property (nonatomic, strong) UITapGestureRecognizer * tap;
@property (nonatomic, assign) CGRect startFrame;
@property (nonatomic, assign) CGFloat HeaderHeight;

@end

@implementation HomeDetailView

- (instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)dataDic
{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        self.startFrame = frame;
        [self dealWithData:dataDic];
        [self createViews];
        self.layer.cornerRadius = 10.f;
        
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
    self.topModel.contentType = 1;
    [self.dataSource addObject:self.topModel];
    
    NSArray *resultArr = [dataDict objectForKey:@"list"];
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
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endScrrenToShow)];
    self.tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tap];
    self.tap.enabled = NO;
    
    [self setUpMaxStyle];
    [self setUpMinStyle];
}

- (void)setUpMinStyle
{
    CGFloat topHeight = self.bounds.size.width / 750.f * 488.f;
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topHeight)];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.layer.masksToBounds = YES;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:self.topModel.img_url]];
    
    self.bottoView = [[UIView alloc] initWithFrame:CGRectMake(0, topHeight, self.bounds.size.width, self.bounds.size.height - topHeight)];
    [self addSubview:self.bottoView];
    self.bottoView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.bottoView.frame.size.width - 30, self.bottoView.frame.size.height - 30)];
    self.subTitleLabel.text = self.topModel.desc;
    self.subTitleLabel.font = kPingFangLight(15);
    self.subTitleLabel.textColor = UIColorFromRGB(0x575757);
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.numberOfLines = 0;
    [self.bottoView addSubview:self.subTitleLabel];
    [self configSubTitleWithWidth:self.bottoView.frame.size.width - 30];
}

- (void)configSubTitleWithWidth:(CGFloat)width
{
    CGRect frame = self.subTitleLabel.frame;
    frame.size.width = width;
    self.subTitleLabel.frame = frame;
    
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
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    self.subTitleLabel.attributedText = attrString;
    
    // 计算富文本的高度
    CGFloat descHeight = [self.subTitleLabel sizeThatFits:self.subTitleLabel.bounds.size].height;
    self.subTitleLabel.frame = CGRectMake(15, 15, width, descHeight);
}

- (void)setUpMaxStyle
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeDetailCell"];
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
    // 1 文字  2 文章  3 图片  4 标题
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
    if (model.contentType == 1) {
        CGFloat titleHeight = [ZXTools getHeightByWidth:kMainBoundsWidth - 30 title:model.title font:kPingFangMedium(22)];
        if (titleHeight > 31) {
            return  62 + 36  + 25;
        }else{
            return  31 + 36 + 25;
        }
    }else if (model.sgtype == 3) {
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
    self.tableView.frame = CGRectMake(-self.startFrame.origin.x, -self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
    
    [self addSubview:self.topImageView];
    
    [UIView animateWithDuration:HomeDetailViewShowAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
        [self.topView startScrShow];
        self.tableView.frame = self.bounds;
        self.topImageView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 750.f * 488.f);
        self.bottoView.frame = CGRectMake(0, kMainBoundsWidth / 750.f * 488.f, kMainBoundsWidth, kMainBoundsHeight - kMainBoundsWidth / 750.f * 488.f);
//        [self configSubTitleWithWidth:self.bottoView.bounds.size.width - 30];
        CGRect frame = self.subTitleLabel.bounds;
        self.subTitleLabel.frame = CGRectMake((kMainBoundsWidth - frame.size.width) / 2, (kMainBoundsHeight - self.topImageView.frame.size.height) / 2, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        self.tap.enabled = YES;
        [self.topImageView removeFromSuperview];
        self.layer.cornerRadius = 0.f;
    }];
    
    [UIView animateWithDuration:HomeDetailViewShowAnimationDuration / 2 animations:^{
        self.bottoView.alpha = .2f;
        self.tableView.alpha = .2f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:HomeDetailViewShowAnimationDuration / 2 animations:^{
            self.bottoView.alpha = 0;
            self.tableView.alpha = 1;
        }];
    }];
}

- (void)endScrrenToShow
{
    self.tap.enabled = NO;
    
    [self addSubview:self.topImageView];
    self.layer.cornerRadius = 10.f;
    
    [UIView animateWithDuration:HomeDetailViewHiddenAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = self.startFrame;
         [self.topView endScrShow];
        self.topImageView.frame = CGRectMake(0, 0, self.startFrame.size.width, self.startFrame.size.width / 750.f * 488.f);
        self.tableView.frame = CGRectMake(-self.startFrame.origin.x, -self.startFrame.origin.y, kMainBoundsWidth, kMainBoundsHeight);
        self.bottoView.frame = CGRectMake(0, self.startFrame.size.width / 750.f * 488.f, self.startFrame.size.width, self.startFrame.size.height - self.startFrame.size.width / 750.f * 488.f);
        CGRect frame = self.subTitleLabel.bounds;
        self.subTitleLabel.frame = CGRectMake(15, 15, frame.size.width, frame.size.height);
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

@end
