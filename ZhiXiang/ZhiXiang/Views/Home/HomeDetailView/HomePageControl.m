//
//  HomePageControl.m
//  ZhiXiang
//
//  Created by 郭春城 on 2017/9/25.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomePageControl.h"
#import "UIView+LayerCurve.h"

@interface HomePageControl ()

@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, strong) UILabel * currentLabel;
@property (nonatomic, strong) UILabel * totalLabel;

@end

@implementation HomePageControl

- (instancetype)initWithTotalNumber:(NSInteger)totalNumber
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 33)]) {
        self.totalNumber = totalNumber;
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.bounds.size.width / 2 - 3.5, 20)];
    self.currentLabel.font = kACaslonProItalic(20);
    self.currentLabel.textAlignment = NSTextAlignmentRight;
    self.currentLabel.textColor = UIColorFromRGB(0x9a9a9a);
    self.currentLabel.text = @"1";
    [self addSubview:self.currentLabel];
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 + 2, 19, self.bounds.size.width / 2 - 1, 13)];
    self.totalLabel.font = kACaslonProRegular(13);
    self.totalLabel.textAlignment = NSTextAlignmentLeft;
    self.totalLabel.textColor = UIColorFromRGB(0x666666);
    self.totalLabel.text = [NSString stringWithFormat:@"%ld", self.totalNumber];
    [self addSubview:self.totalLabel];
    
    CGPoint startPoint = CGPointMake(self.bounds.size.width / 2 + 7, 5);
    CGPoint endPoint = CGPointMake(self.bounds.size.width / 2 - 7, self.bounds.size.height - 5);
    [self layerSolidLinePoints:@[[NSValue valueWithCGPoint:startPoint], [NSValue valueWithCGPoint:endPoint]] Color:UIColorFromRGB(0x666666) Width:1.f];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    self.currentLabel.text = [NSString stringWithFormat:@"%ld", currentIndex];
}

@end
