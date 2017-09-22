//
//  HomeStatusCollectionViewCell.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeStatusCellDelegate <NSObject>

- (void)HomeStatusDidBeRetryLoadData;

@end

@interface HomeStatusCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<HomeStatusCellDelegate> delegate;

- (void)showLoading;

- (void)showNoMoreData;

- (void)showNoNetWork;

@end
