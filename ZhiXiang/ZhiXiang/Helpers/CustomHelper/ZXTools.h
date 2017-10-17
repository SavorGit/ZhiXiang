//
//  ZXTools.h
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/15.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXTools : NSObject

+ (void)configApplication;

+ (NSString *)getCurrentTimeWithFormat:(NSString *)format;

+ (void)saveFileOnPath:(NSString *)path withArray:(NSArray *)array;

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict;

+ (void)removeFileOnPath:(NSString *)path;

+ (CGFloat)getWidthByHeight:(CGFloat)height title:(NSString *)title font:(UIFont *)font;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font lineModel:(NSLineBreakMode)model;

// 计算特定富文本的行高（传入宽度，文字内容，字号）
+ (CGFloat)getAttrHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

// 计算特定富文本的行高,默认字符间距（传入宽度，文字内容，字号）
+ (CGFloat)getAttrHeightByWidthNoSpacing:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

/**
 *  友盟上传事件
 *
 *  @param eventId   事件ID
 *  @param key       事件参数对应的key
 *  @param value       事件参数对应的value
 */
+ (void)postUMHandleWithContentId:(NSString *)eventId key:(NSString *)key value:(NSString *)value;

/**
 *  友盟上传事件
 *
 *  @param eventId   事件ID
 *  @param parmDic   事件参数对应的字典
 */
+ (void)postUMHandleWithContentId:(NSString *)eventId withParmDic:(NSDictionary *)parmDic;

@end
