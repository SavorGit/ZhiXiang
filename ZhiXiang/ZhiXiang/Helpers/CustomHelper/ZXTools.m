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
#import "UMCustomSocialManager.h"
#import <UMMobClick/MobClick.h>
#import "CheckUpdateRequest.h"
#import "RDAlertView.h"

@implementation ZXTools

+ (void)configApplication
{
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[NetworkConfiguration configuration]];
    
    //友盟分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAppkey];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa5ea2522d1a6785e" appSecret:@"b45b77981f464f0a0b88b6c09ff74673" redirectURL:@"http://itunes.apple.com/cn/app/id1284095616"];
    
    //友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    UMConfigInstance.appKey = UmengAppkey;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //仿造设备唯一标识
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    
    //配置用户信息
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoPath]) {
        NSDictionary * userInfo = [NSDictionary dictionaryWithContentsOfFile:UserInfoPath];
        if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
            
            [[UserManager shareManager] configWithDictionary:userInfo];
            
        }else {
            
            [UserManager shareManager].isLoginWithTel = NO;
            [UserManager shareManager].isLoginWithWX = NO;
            
        }
    }
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [self checkUpdate];
}

+ (NSString *)getCurrentTimeWithFormat:(NSString *)format
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
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

+ (CGFloat)autoWidthWith:(CGFloat)width
{
    CGFloat result = (width / 375.f) * kMainBoundsWidth;
    return result;
}

+ (CGFloat)autoHeightWith:(CGFloat)height
{
    CGFloat result = (height / 667.f) * kMainBoundsHeight;
    return result;
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

+ (CGFloat)getWidthByHeight:(CGFloat)height title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return width;
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

+ (CGFloat)getAttrHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger length = [title length];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@1 range:NSMakeRange(0, length)];//字符间距 2pt
    
    label.attributedText = attrString;
    CGFloat height = [label sizeThatFits:label.bounds.size].height;
    
    return height;
}

+ (CGFloat)getAttrHeightByWidthNoSpacing:(CGFloat)width title:(NSString *)title font:(UIFont *)font{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger length = [title length];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    
    label.attributedText = attrString;
    CGFloat height = [label sizeThatFits:label.bounds.size].height;
    
    return height;
}

+ (void)checkUpdate
{
    CheckUpdateRequest * request = [[CheckUpdateRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * info = [response objectForKey:@"result"];
        
        if ([[info objectForKey:@"device_type"] integerValue] == 10) {
            
            NSArray * detailArray =  info[@"remark"];
            
            NSString * detail = @"本次更新内容:\n";
            for (int i = 0; i < detailArray.count; i++) {
                NSString * tempsTr = [detailArray objectAtIndex:i];
                detail = [detail stringByAppendingString:tempsTr];
            }
            
            NSInteger update_type = [[info objectForKey:@"update_type"] integerValue];
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Helper autoWidthWith:320], [Helper autoHeightWith:344])];
            [imageView setImage:[UIImage imageNamed:@"banbengengxin_bg"]];
            imageView.center = CGPointMake(kMainBoundsWidth / 2, kMainBoundsHeight / 2);
            imageView.userInteractionEnabled = YES;
            [view addSubview:imageView];
            
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, [Helper autoHeightWith:75], imageView.frame.size.width - 40, imageView.frame.size.height - [Helper autoHeightWith:155])];
            [imageView addSubview:scrollView];
            
            CGRect rect = [detail boundingRectWithSize:CGSizeMake(scrollView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height + 20)];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:15];
            label.text = detail;
            [scrollView addSubview:label];
            scrollView.contentSize = label.frame.size;
            
            if (update_type == 1) {
                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1284095616"]];
                    
                } bold:YES];
                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width + 20, [Helper autoHeightWith:35]);
                [imageView addSubview:leftButton];
            }else if (update_type == 0) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.size.width / 2, imageView.frame.size.height - [Helper autoHeightWith:50], .5f, [Helper autoHeightWith:35])];
                lineView.backgroundColor = UIColorFromRGB(0xb6a482);
                [imageView addSubview:lineView];
                
                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"取消" handler:^{
                    [view removeFromSuperview];
                    
                } bold:NO];
                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
                [imageView addSubview:leftButton];
                
                RDAlertAction * righButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
                    [view removeFromSuperview];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1284095616"]];
                } bold:YES];
                righButton.frame =  CGRectMake(leftButton.frame.size.width + leftButton.frame.origin.x, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
                [imageView addSubview:righButton];
            }
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

+ (void)postUMHandleWithContentId:(NSString *)eventId key:(NSString *)key value:(NSString *)value
{
    if (key.length > 0 && value.length > 0) {
        [MobClick event:eventId attributes:@{key : value}];
    }else{
        [MobClick event:eventId];
    }
}

+ (void)postUMHandleWithContentId:(NSString *)eventId withParmDic:(NSDictionary *)parmDic{
    if (parmDic != nil) {
        [MobClick event:eventId attributes:parmDic];
    }
}

@end
