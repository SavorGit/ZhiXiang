//
//  HomeCollectionViewCell.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@interface HomeCollectionViewCell : UICollectionViewCell

- (void)configModelData:(HomeViewModel *)model;

@end
