//
//  ZXTools.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXTools.h"
#import "BGNetWorkManager.h"
#import "NetworkConfiguration.h"
#import "GCCKeyChain.h"
#import "Helper.h"

@implementation ZXTools

+ (void)configApplication
{
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[NetworkConfiguration configuration]];
    //item字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    //设置标题颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    
//    [self checkUpdate];
}

+ (void)saveFileOnPath:(NSString *)path withArray:(NSArray *)array
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:FileCachePath]) {
        [manager createDirectoryAtPath:FileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    BOOL temp = [array writeToFile:path atomically:YES];
    if (temp) {
        NSLog(@"缓存成功");
    }else{
        NSLog(@"缓存失败");
    }
}

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:FileCachePath]) {
        [manager createDirectoryAtPath:FileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    BOOL temp = [dict writeToFile:path atomically:YES];
    if (temp) {
        NSLog(@"缓存成功");
    }else{
        NSLog(@"缓存失败");
    }
}

+ (void)removeFileOnPath:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font lineModel:(NSLineBreakMode)model
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.lineBreakMode = model;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (void)checkUpdate
{
//    CheckUpdateRequest * request = [[CheckUpdateRequest alloc] init];
//    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
//        
//        NSDictionary * info = [response objectForKey:@"result"];
//        
//        if ([[info objectForKey:@"device_type"] integerValue] == 6) {
//            
//            NSArray * detailArray =  info[@"remark"];
//            
//            NSString * detail = @"本次更新内容:\n";
//            for (int i = 0; i < detailArray.count; i++) {
//                NSString * tempsTr = [detailArray objectAtIndex:i];
//                detail = [detail stringByAppendingString:tempsTr];
//            }
//            
//            NSInteger update_type = [[info objectForKey:@"update_type"] integerValue];
//            
//            UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
//            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
//            [[UIApplication sharedApplication].keyWindow addSubview:view];
//            [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(0);
//            }];
//            
//            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Helper autoWidthWith:320], [Helper autoHeightWith:344])];
//            [imageView setImage:[UIImage imageNamed:@"banbengengxin_bg"]];
//            imageView.center = CGPointMake(kMainBoundsWidth / 2, kMainBoundsHeight / 2);
//            imageView.userInteractionEnabled = YES;
//            [view addSubview:imageView];
//            
//            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, [Helper autoHeightWith:75], imageView.frame.size.width - 40, imageView.frame.size.height - [Helper autoHeightWith:155])];
//            [imageView addSubview:scrollView];
//            
//            CGRect rect = [detail boundingRectWithSize:CGSizeMake(scrollView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//            
//            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height + 20)];
//            label.textColor = [UIColor blackColor];
//            label.numberOfLines = 0;
//            label.font = [UIFont systemFontOfSize:15];
//            label.text = detail;
//            [scrollView addSubview:label];
//            scrollView.contentSize = label.frame.size;
//            
//            if (update_type == 1) {
//                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1253304503"]];
//                    
//                } bold:YES];
//                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width + 20, [Helper autoHeightWith:35]);
//                [imageView addSubview:leftButton];
//            }else if (update_type == 0) {
//                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.size.width / 2, imageView.frame.size.height - [Helper autoHeightWith:50], .5f, [Helper autoHeightWith:35])];
//                lineView.backgroundColor = UIColorFromRGB(0xb6a482);
//                [imageView addSubview:lineView];
//                
//                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"取消" handler:^{
//                    [view removeFromSuperview];
//                    
//                } bold:NO];
//                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
//                [imageView addSubview:leftButton];
//                
//                RDAlertAction * righButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
//                    [view removeFromSuperview];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1253304503"]];
//                } bold:YES];
//                righButton.frame =  CGRectMake(leftButton.frame.size.width + leftButton.frame.origin.x, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
//                [imageView addSubview:righButton];
//            }
//        }
//        
//        
//    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
//        
//    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
//        
//    }];
}

@end
