//
//  ZXKeyWordsView.m
//  每日知享test
//
//  Created by 郭春城 on 2017/9/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXKeyWordsView.h"
#import "Masonry.h"

static CGFloat minMarginDistance = 40.0; //距离屏幕边缘的最小距离
static CGFloat itemDistance = 44.0; //各个keyWord之间的距离
static CGFloat fontSize = 16.0; //字体大小
static CGFloat keyWordViewAnimationDuration = 2.0;

@interface ZXKeyWordsView ()

@property (nonatomic, strong) NSMutableArray * keyWords;
@property (nonatomic, assign) NSInteger lineNum;

@end

@implementation ZXKeyWordsView

- (instancetype)initWithKeyWordArray:(NSArray *)words
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.keyWords = [[NSMutableArray alloc] initWithArray:words];
        [self createViews];
        
    }
    return self;
}

- (void)createViews
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    self.lineNum = 0;
    
    NSMutableArray * lineKeyWords = [NSMutableArray new]; //存储一行的关键字
    CGFloat totalWidth = minMarginDistance + minMarginDistance; //记录当前行的宽度
    for (NSInteger i = 0; i < self.keyWords.count; i++) {
        //遍历计算某一行加上关键字后的宽度
        NSString * keyWord = [self.keyWords objectAtIndex:i];
        CGFloat width = [self getWidthByKeyWord:keyWord];
        totalWidth += width; //加上该关键字宽度
        if (lineKeyWords.count == 0) {
            [lineKeyWords addObject:keyWord];
        }else{
            totalWidth += itemDistance; //加上关键字间隔宽度
            if (totalWidth > [UIScreen mainScreen].bounds.size.width) {
                totalWidth = totalWidth - width - itemDistance - minMarginDistance - minMarginDistance; //计算出当前除了两边距离的所需宽度
                [self createLineWithKeyWords:[NSArray arrayWithArray:lineKeyWords] totalWidth:totalWidth];
                [lineKeyWords removeAllObjects];
                totalWidth = minMarginDistance + minMarginDistance;
                i--;
            }else{
                [lineKeyWords addObject:keyWord];
            }
        }
        
        if (i == self.keyWords.count - 1) {
            if (lineKeyWords.count != 0) {
                //计算出当前除了两边距离的所需宽度
                totalWidth = totalWidth - minMarginDistance - minMarginDistance;
                [self createLineWithKeyWords:[NSArray arrayWithArray:lineKeyWords] totalWidth:totalWidth];
                totalWidth = minMarginDistance + minMarginDistance;
            }
        }
        
    }
    
}

- (void)createLineWithKeyWords:(NSArray *)array totalWidth:(CGFloat)totalWidth
{
    self.lineNum++;
    
    CGFloat delay = (self.lineNum - 1) * .7;
    
    if (array.count == 1) {
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineNum * 50 + 150 + 15, [UIScreen mainScreen].bounds.size.width, 20)];
        [self addSubview:lineView];
        
        UILabel * label = [self labelWithKeyWord:[array firstObject]];
        [lineView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self keyWordView:lineView AnimationAfterDelay:delay];
    }else{
        CGFloat margin = ([UIScreen mainScreen].bounds.size.width - totalWidth) / 2;
        UILabel * lastLabel;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineNum * 50 + 150 + 15, [UIScreen mainScreen].bounds.size.width, 20)];
        [self addSubview:lineView];
        for (NSInteger i = 0; i < array.count; i++) {
            NSString * keyWord = [array objectAtIndex:i];
            
            UILabel * label = [self labelWithKeyWord:keyWord];
            [lineView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                if (lastLabel) {
                    make.left.mas_equalTo(lastLabel.mas_right).offset(itemDistance);
                }else{
                    make.left.mas_equalTo(margin);
                }
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo([self getWidthByKeyWord:keyWord]);
            }];
            lastLabel = label;
        }
        [self keyWordView:lineView AnimationAfterDelay:delay];
    }
}

- (void)keyWordView:(UIView *)view AnimationAfterDelay:(CGFloat)delay
{
    CGRect frame = view.frame;
    frame.origin.y -= 15;
    view.layer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 1, 0, 0);
    view.alpha = 0.4;
    
    [UIView animateWithDuration:keyWordViewAnimationDuration delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.layer.transform = CATransform3DRotate(CATransform3DIdentity, 0, 1, 0, 0);
        view.frame = frame;
        view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (UILabel *)labelWithKeyWord:(NSString *)keyWord
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = keyWord;
    label.textColor = [UIColor whiteColor];
    return label;
}

- (CGFloat)getWidthByKeyWord:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontSize, 0)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
