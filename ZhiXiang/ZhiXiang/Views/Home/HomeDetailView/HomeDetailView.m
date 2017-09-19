//
//  HomeDetailView.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeDetailView.h"

CGFloat HomeDetailViewAnimationDuration = .4f;

@interface HomeDetailView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UITapGestureRecognizer * tap;

@property (nonatomic, assign) CGRect startFrame;

@end

@implementation HomeDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.startFrame = frame;
        [self createViews];
        
    }
    return self;
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
    self.tableView.tableHeaderView = self.headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeDetailCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"测试一下这里的动画能不能正常进行";
    cell.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)becomeScreenToRead
{
    CGFloat width = kMainBoundsWidth;
    CGFloat height = kMainBoundsHeight;
    [UIView animateWithDuration:HomeDetailViewAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.headerView.frame = CGRectMake(0, 0, width, 200);
        self.frame = CGRectMake(0, 0, width, height);
        self.tableView.frame = self.bounds;
    } completion:^(BOOL finished) {
        self.tap.enabled = YES;
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
