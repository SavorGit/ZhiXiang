//
//  ResAddSliderViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ResSliderLibraryModel.h"

@interface ResAddSliderViewController : ZXBaseViewController

- (instancetype)initWithSliderModel:(ResSliderLibraryModel *)model block:(void(^)(NSDictionary * item))block;

@end
