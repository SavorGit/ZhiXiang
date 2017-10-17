//
//  LeftTableViewCell.h
//  ZhiXiang
//
//  Created by 王海朋 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewCell : UITableViewCell

- (void)hiddenLineView:(BOOL)isHidden;

- (void)configTitle:(NSString *)title andImage:(NSString *)imageStr;

@end
