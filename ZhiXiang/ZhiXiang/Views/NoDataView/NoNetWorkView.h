//  NoNetWorkView.h
//  TuanChe
//
//  Created by 家伟 李 on 14-6-26.
//  Copyright (c) 2014年 家伟 李. All rights reserved.
//

typedef enum
{
    NoNetWorkViewStyle_No_NetWork=0,
    NoNetWorkViewStyle_Load_Fail
}NoNetWorkViewStyle;
@protocol NoNetWorkViewDelegate ;
@interface NoNetWorkView : UIView

@property (weak,nonatomic) id<NoNetWorkViewDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t reloadDataBlock;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

-(void)showInView:(UIView*)superView style:(NoNetWorkViewStyle)style;
-(void)hide;

/**
 *  加载与类名相同名字的XIB文件
 *
 *  @return 返回一个视图对象
 */
+ (id)loadFromXib;

@end

@protocol NoNetWorkViewDelegate <NSObject>

-(void)retryToGetData;

@end
