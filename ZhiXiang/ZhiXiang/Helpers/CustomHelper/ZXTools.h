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

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font lineModel:(NSLineBreakMode)model;

// 计算特定富文本的行高（传入宽度，文字内容，字号）
+ (CGFloat)getAttrHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

// 计算特定富文本的行高,默认字符间距（传入宽度，文字内容，字号）
+ (CGFloat)getAttrHeightByWidthNoSpacing:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

@end
