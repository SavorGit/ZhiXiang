//
//  ZXDetailArticleViewController.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXBaseViewController.h"

@protocol ZXDetailArticleViewControllerDelegate <NSObject>

- (void)ZXDetailarticleWillDismiss;

@end

@interface ZXDetailArticleViewController : ZXBaseViewController

@property (nonatomic, assign) id<ZXDetailArticleViewControllerDelegate> delegate;

- (instancetype)initWithtopDailyID:(NSString *)dailyid;

@end
