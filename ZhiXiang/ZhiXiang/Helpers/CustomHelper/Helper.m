//
//  Helper.m
//  HotSpot
//
//  Created by lijiawei on 16/12/8.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "Helper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>
#import "GCCKeyChain.h"
#import "GCCGetInfo.h"

@implementation Helper

+ (NSInteger)getCurrentTime
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger result = (NSInteger)time;
    return result;
}

//获取当前时间戳
+(NSString *)getTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

+ (NSString *)getTimeStampMS
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//获取NSBundele中的资源图片
+ (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName {
    if(fileName) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
        path = [NSString stringWithFormat:@"%@@2x.%@",path,[fileName pathExtension]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            path = nil;
        }
        
        if(!path) {
            path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        }
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

+ (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (BOOL)isWifiStatus
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return NO;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            if (wifiName.length > 0) {
                return YES;
            }
        }
    }
    
    CFRelease(wifiInterfaces);
    return NO;
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

+ (NSString *)getMd5_32Bit:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)getURLPublic
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    NSString *mdStr = [timeString stringByAppendingString:@"savor4321abcd1234"];
    NSString * result = [Helper getMd5_32Bit:mdStr];
    result = [NSString stringWithFormat:@"time=%@&sign=%@&deviceId=%@", timeString, result, [GCCKeyChain load:keychainID]];

    return result;
}

+ (NSString *)getHTTPHeaderValue
{
    NSString * result = [NSString stringWithFormat:@"versionname=%@;versioncode=%d;osversion=%@;model=%@;appname=hotSpot;clientname=ios;channelName=appstore;deviceid=%@;location=0,0", kSoftwareVersion, kVersionCode, [UIDevice currentDevice].systemVersion, [GCCGetInfo getDeviceName], [GCCKeyChain load:keychainID]];
    return result;
}

+ (NSString *)getCurrentTimeWithFormat:(NSString *)format
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (NSString *)transformDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (BOOL) isBlankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)addURLParamsShareWith:(NSString *)url
{
    if ([url containsString:@"?"]) {
        return [url stringByAppendingString:@"&app=inner"];
    }else{
        return [url stringByAppendingString:@"?app=inner"];
    }
}

@end
