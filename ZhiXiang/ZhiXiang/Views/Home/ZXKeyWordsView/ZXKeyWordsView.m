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
static CGFloat keyWordViewAnimationDuration = .7;

@interface ZXKeyWordsView ()

@property (nonatomic, strong) UIToolbar * baseView;
@property (nonatomic, strong) UIScrollView * scrollView;
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
    self.lineNum = 0;
    
    self.baseView = [[UIToolbar alloc] initWithFrame:self.bounds];
    self.baseView.barStyle = UIBarStyleBlackTranslucent;
    [self addSubview:self.baseView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, [self scaleHeightWith:105], [UIScreen mainScreen].bounds.size.width, 20)];
    label.font = kPingFangRegular(17);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"今日关键词";
    label.textColor = UIColorFromRGB(0xeeeeee);
    [self.scrollView addSubview:label];
}

- (void)createKeyWordViews
{
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
                [self createButtonWithIKnewIt];
                totalWidth = minMarginDistance + minMarginDistance;
            }
        }
        
    }
}

//创建我知道了的按钮
- (void)createButtonWithIKnewIt
{
    CGFloat topDistance = self.lineNum * 47 + [self scaleHeightWith:290] - 47;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 80) / 2,topDistance + 10, 80, 30);
    [button setTitleColor:UIColorFromRGB(0xeeeeee) forState:UIControlStateNormal];
    button.titleLabel.font = kPingFangLight(16);
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    button.layer.borderWidth = .5;
    [button addTarget:self action:@selector(IKnewItButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    [self keyWordView:button AnimationAfterDelay:self.lineNum * .7];
}

- (void)IKnewItButtonDidBeClicked
{
    [self hiddenWithAnimation:YES];
}

//创建某一行的关键词
- (void)createLineWithKeyWords:(NSArray *)array totalWidth:(CGFloat)totalWidth
{
    self.lineNum++;
    
    CGFloat delay = (self.lineNum - 1) * .7;
    
    CGFloat topDistance = [self scaleHeightWith:200] - 47;
    
    if (array.count == 1) {
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineNum * 47 + topDistance, [UIScreen mainScreen].bounds.size.width, 20)];
        [self.scrollView addSubview:lineView];
        
        UILabel * label = [self labelWithKeyWord:[array firstObject]];
        [lineView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self keyWordView:lineView AnimationAfterDelay:delay];
    }else{
        CGFloat margin = ([UIScreen mainScreen].bounds.size.width - totalWidth) / 2;
        UILabel * lastLabel;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineNum * 47 + topDistance, [UIScreen mainScreen].bounds.size.width, 20)];
        [self.scrollView addSubview:lineView];
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
    
    CGFloat totalHeight = frame.origin.y + frame.size.height + [self scaleHeightWith:150];
    if (totalHeight > self.scrollView.contentSize.height) {
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height = totalHeight;
        self.scrollView.contentSize = contentSize;
    }
    
    [UIView animateWithDuration:keyWordViewAnimationDuration delay:delay usingSpringWithDamping:0.4 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.layer.transform = CATransform3DRotate(CATransform3DIdentity, 0, 1, 0, 0);
        view.frame = frame;
        view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (UILabel *)labelWithKeyWord:(NSString *)keyWord
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = kPingFangRegular(fontSize);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = keyWord;
    label.textColor = UIColorFromRGB(0xe7e3d1);
    return label;
}

- (CGFloat)getWidthByKeyWord:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontSize, 0)];
    label.text = title;
    label.font = kPingFangRegular(fontSize);
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return width;
}

- (CGFloat)scaleHeightWith:(CGFloat)height;
{
    CGFloat scale = [UIScreen mainScreen].bounds.size.height / 667.f;
    return height * scale;
}

- (void)showWithAnimation:(BOOL)animation
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (animation) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = -frame.size.height;
        self.frame = frame;
        
        [UIView animateWithDuration:.3f animations:^{
            self.frame = [UIScreen mainScreen].bounds;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createKeyWordViews];
            });
        }];
    }else{
        [self createKeyWordViews];
    }
}

- (void)hiddenWithAnimation:(BOOL)animation
{
    if (animation) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = -frame.size.height;
        
        [UIView animateWithDuration:.4f animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
