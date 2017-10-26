//
//  MBProgressHUD+Custom.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MBProgressHUD+Custom.h"

@implementation MBProgressHUD (Custom)

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    
    return hud;
}

+ (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view
{
    if (isEmptyString(text)) {
        return;
    }
    
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:677];
    if (tempView) {
        [tempView removeFromSuperview];
    }
        
    CGRect rect = [text boundingRectWithSize:CGSizeMake(view.frame.size.width - 60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kPingFangLight(17)} context:nil];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 30, rect.size.height + 20)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.75f];
    backView.layer.cornerRadius = 5.f;
    backView.clipsToBounds = YES;
    backView.tag = 677;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    label.center = CGPointMake(backView.frame.size.width / 2, backView.frame.size.height / 2);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kPingFangLight(17);
    
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rect.size.width + 30);
        make.height.mas_equalTo(rect.size.height + 20);
        make.center.mas_equalTo(0);
    }];
    
    [backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rect.size.width + 10);
        make.height.mas_equalTo(rect.size.height + 10);
        make.center.mas_equalTo(0);
    }];
    
    backView.alpha = 0.f;
    [UIView animateWithDuration:.2f animations:^{
        backView.alpha = 1.f;
    }];
    
    [UIView animateWithDuration:0.5f delay:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//
//    // Set the text mode to show only text.
//    hud.mode = MBProgressHUDModeText;
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
//    hud.label.font = kPingFangLight(16);
//    hud.label.text = text;
//    hud.label.textColor = [UIColor whiteColor];
//    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, 0.f);
//
//    [hud hideAnimated:YES afterDelay:1.f];
//    return hud;
}

+ (MBProgressHUD *)showSuccessWithText:(NSString *)text inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = text;
    
    [hud hideAnimated:YES afterDelay:1.f];
    
    return hud;
}

@end
