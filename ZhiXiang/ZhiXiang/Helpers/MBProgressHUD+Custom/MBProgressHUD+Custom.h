//
//  MBProgressHUD+Custom.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Custom)

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text inView:(UIView *)view;

+ (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view;

+ (MBProgressHUD *)showSuccessWithText:(NSString *)text inView:(UIView *)view;

@end
