//
//  HeaderTableViewCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@interface HeaderTableViewCell : UITableViewCell

- (void)configModelData:(HomeViewModel *)model;

@end
