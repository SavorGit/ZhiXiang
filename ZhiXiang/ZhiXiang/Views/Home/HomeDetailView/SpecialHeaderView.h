//
//  SpecialHeaderView.h
//  SavorX
//
//  Created by 王海朋 on 2017/8/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@interface SpecialHeaderView : UIView

- (void)configModelData:(HomeViewModel *)model;

- (void)startScrShow;

- (void)endScrShow;

@end
