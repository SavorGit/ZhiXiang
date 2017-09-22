//
//  ZXBaseViewController.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "AFNetworkReachabilityManager.h"

@interface ZXBaseViewController ()<NoDataViewDelegate,NoNetWorkViewDelegate>{
    
    /**无数据视图**/
    NoDataView*         _noDataView;
    /**无网视图**/
    NoNetWorkView*      _noNetWorkView;
    
}

@property (nonatomic, strong) UILabel * TopFreshLabel;

@end

@implementation ZXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
}

- (void)setupDatas
{
}

/**
 *  显示无数据视图
 *
 *  @param frame 内容显示的frame
 */
- (void)showNoDataViewWithFrame:(CGRect)frame{
    if (!_noDataView) {
        _noDataView = [NoDataView loadFromXib];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataViewController:self noDataType:kNoDataType_Default];
    [_noDataView setContentViewFrame:frame];
}

- (void)showNoDataViewWithFrame:(CGRect)frame noDataType:(NODataType)type{
    if (!_noDataView) {
        _noDataView = [NoDataView loadFromXib];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataViewController:self noDataType:type];
    [_noDataView setContentViewFrame:frame];
}

- (void)showNoDataViewInView:(UIView *)superView{
    if (!_noDataView) {
        _noDataView = [NoDataView loadFromXib];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataView:superView noDataType:kNoDataType_Default];
}
- (void)showNoDataViewInView:(UIView *)superView noDataString:(NSString *)noDataString
{
    if (!_noDataView) {
        _noDataView = [NoDataView loadFromXib];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataView:superView noDataString:noDataString];
}

- (void)showNoDataViewBelowView:(UIView *)view noDataType:(NODataType)type
{
    if (!_noDataView) {
        _noDataView = [NoDataView loadFromXib];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataBelowView:view noDataType:type];
}

-(void)showNoDataViewInView:(UIView*)superView noDataType:(NODataType)type{
    
    if (!_noDataView) {
        _noDataView = [NoDataView loadFromXib];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataView:superView noDataType:type];
    
}

- (void)showNoDataView
{
    [self showLoadFailView:YES noDataType:0];
}

- (void)hideNoDataView
{
    [self showLoadFailView:NO noDataType:0];
}

- (void)showLoadFailView:(BOOL)isShow noDataType:(NODataType)nodataType{
    if(isShow){
        if (!_noDataView) {
            _noDataView = [NoDataView loadFromXib];
            _noDataView.delegate = self;
        }
        [_noDataView showNoDataViewController:self noDataType:nodataType];
    }
    else{
        [_noDataView hide];
    }
}


#pragma mark - show or hide noNetWorkView method
-(void)showNoNetWorkView{
    [self showNoNetWorkViewInView:self.view];
}

- (void)showNoNetWorkView:(NoNetWorkViewStyle)style{
    return [self showNoNetWorkViewInView:self.view frame:self.view.bounds style:style];
}

- (void)showNoNetWorkViewWithFrame:(CGRect)frame{
    [self showNoNetWorkViewInView:self.view frame:frame];
}

-(void)showNoNetWorkViewInView:(UIView *)view{
    [self showNoNetWorkViewInView:view frame:view.bounds];
}

- (void)showNoNetWorkViewInView:(UIView *)view frame:(CGRect)frame{
    NoNetWorkViewStyle style = NoNetWorkViewStyle_No_NetWork;
    AFNetworkReachabilityStatus networkStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if(networkStatus == AFNetworkReachabilityStatusReachableViaWiFi || networkStatus == AFNetworkReachabilityStatusReachableViaWWAN){
        //加载失败
        style = NoNetWorkViewStyle_Load_Fail;
    }
    [self showNoNetWorkViewInView:view frame:frame style:style];
}

- (void)showNoNetWorkViewInView:(UIView *)view frame:(CGRect)frame style:(NoNetWorkViewStyle)style{
    if (!_noNetWorkView) {
        _noNetWorkView = [NoNetWorkView loadFromXib];
        _noNetWorkView.delegate = self;
    }
    [_noNetWorkView showInView:view style:style];
    _noNetWorkView.frame = frame;
}

-(void)hideNoNetWorkView
{
    [_noNetWorkView hide];
}

//Overide method
#pragma mark NoNetWorkViewDelegate
-(void)retryToGetData{
    
}

//页面顶部下弹状态栏显示
- (void)showTopFreshLabelWithTitle:(NSString *)title
{
    
    //移除当前动画
    [self.TopFreshLabel.layer removeAllAnimations];
    
    //取消延时重置状态栏
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetTopFreshLabel) object:nil];
    
    //重新设置状态栏下弹动画
    self.TopFreshLabel.text = title;
    self.TopFreshLabel.frame = CGRectMake(0, -35, kMainBoundsWidth, 35);
    [self.view bringSubviewToFront:self.TopFreshLabel];
    [UIView animateWithDuration:.5f animations:^{
        self.TopFreshLabel.frame = CGRectMake(0, 0, kMainBoundsWidth, 35);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(resetTopFreshLabel) withObject:nil afterDelay:2.f];
    }];
}

//重置页面顶部下弹状态栏
- (void)resetTopFreshLabel
{
    [UIView animateWithDuration:.5f animations:^{
        self.TopFreshLabel.frame = CGRectMake(0, -35, kMainBoundsWidth, 35);
    }];
}

- (UILabel *)TopFreshLabel
{
    if (!_TopFreshLabel) {
        _TopFreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -35, kMainBoundsWidth, 35)];
        _TopFreshLabel.textAlignment = NSTextAlignmentCenter;
        _TopFreshLabel.backgroundColor = [UIColorFromRGB(0xffebc3) colorWithAlphaComponent:.96f];
        _TopFreshLabel.font = [UIFont systemFontOfSize:15];
        _TopFreshLabel.textColor = UIColorFromRGB(0x9a6f45);
        [self.view addSubview:_TopFreshLabel];
    }
    return _TopFreshLabel;
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
