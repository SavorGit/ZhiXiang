//
//  HomeViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeViewController.h"
#import "TYCyclePagerView.h"
#import "HomeCollectionViewCell.h"
#import "ZXKeyWordsView.h"

@interface HomeViewController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日知享";
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.pagerView = [[TYCyclePagerView alloc]init];
    self.pagerView.isInfiniteLoop = NO;
    self.pagerView.dataSource = self;
    self.pagerView.delegate = self;
    // registerClass or registerNib
    [self.pagerView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.view addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-70);
        make.right.mas_equalTo(0);
    }];
    self.currentIndex = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * keyWords = @[@"iPhone X", @"孙宏斌", @"美联储", @"蒂芙尼珠宝", @"北海道肉蟹", @"贵族学校", @"百年普洱", @"小米", @"特朗普", @"蒂芙尼哈哈", @"法拉利的遗憾", @"品茶道人生"];
        ZXKeyWordsView * keyWordView = [[ZXKeyWordsView alloc] initWithKeyWordArray:keyWords];
        [keyWordView showWithAnimation:YES];
    });
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 20;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    HomeCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndex:index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kMainBoundsWidth - 60, kMainBoundsHeight - kStatusBarHeight - kNaviBarHeight - 30 - 70);
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (index == self.currentIndex) {
        NSLog(@"点击了%ld", index);
    }else{
//        self.pagerView.userInteractionEnabled = NO;
//        [self.pagerView scrollToItemAtIndex:index animate:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.pagerView.userInteractionEnabled = YES;
//        });
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.currentIndex = toIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
