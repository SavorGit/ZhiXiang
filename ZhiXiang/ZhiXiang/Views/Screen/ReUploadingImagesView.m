//
//  ReUploadingImagesView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/6/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReUploadingImagesView.h"
#import <Photos/Photos.h>
#import "ZXTools.h"
#import "RDAlertView.h"

@interface ReUploadingImagesView()

@property(nonatomic ,strong)UILabel *percentageLab;

@property (nonatomic, strong) NSDictionary * uploadParams;
@property (nonatomic, strong) NSArray * imageInfoArray;
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger failedCount;

@end

@implementation ReUploadingImagesView

- (instancetype)initWithImagesArray:(NSArray *)imageArr otherDic:(NSDictionary *)parmDic handler:(void (^)(NSError *))handler{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
         self.block = handler;
        self.uploadParams = parmDic;
        self.currentIndex = 0;
        self.failedCount = 0;
         [self creatSubViews];
        
        // 延迟三秒发送网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dealWithSlideInfo:imageArr];
        });
        
    }
    return self;
}

- (void)creatSubViews{
    
    self.tag = 10001;
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.92f];
    
    self.percentageLab = [[UILabel alloc] init];
    self.percentageLab.font = [UIFont systemFontOfSize:24];
    self.percentageLab.textColor = UIColorFromRGB(0xff6a2f);
    self.percentageLab.backgroundColor = [UIColor clearColor];
    self.percentageLab.textAlignment = NSTextAlignmentCenter;
    self.percentageLab.text = @"0%";
    [self addSubview:self.percentageLab];
    [self.percentageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerY.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
    }];
    
    UILabel *conLabel = [[UILabel alloc] init];
    conLabel.font = [UIFont systemFontOfSize:16];
    conLabel.textColor = UIColorFromRGB(0xffffff);
    conLabel.backgroundColor = [UIColor clearColor];
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.text = @"正在载入幻灯片";
    [self addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.percentageLab.mas_bottom).offset(8);
    }];
}

// 处理上传信息数据
- (void)dealWithSlideInfo:(NSArray *)dataArray{
    
    NSMutableArray *imgInfoArr = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < dataArray.count; i++) {
        NSString * str = [dataArray objectAtIndex:i];
        PHAsset * currentAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
        if (currentAsset) {
            NSString *picName = currentAsset.localIdentifier;
            NSString *nameStr=[picName stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"name",@"0",@"exist",nil];
            [imgInfoArr addObject:tmpDic];
        }
    }
    self.imageInfoArray = [NSArray arrayWithArray:imgInfoArr];
    [self requestNetUpSlideInfoWithForce:0 complete:NO];
}

// 上传幻灯片信息
- (void)requestNetUpSlideInfoWithForce:(NSInteger )force complete:(BOOL)complete{
    
//    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080",[GlobalData shared].boxUrlStr];
    
    [self upLoadImages];
}

- (void)setProgressLabelTextWithProgress:(NSDictionary *)object
{
    self.percentageLab.text = [object objectForKey:@"progress"];
}

// 上传幻灯片图片
- (void)upLoadImages
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"12%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"23%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"41%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"56%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"78%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"93%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"100%";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.23f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.percentageLab.text = @"100%";
        self.block(nil);
    });
//
//    if (self.failedCount >= 3) {
//        self.block([NSError errorWithDomain:@"com.uploadImage" code:204 userInfo:nil]);
//        return;
//    }
//
//    PHImageRequestOptions * option = [PHImageRequestOptions new];
//    option.resizeMode = PHImageRequestOptionsResizeModeExact; //标准的图片尺寸
//    option.networkAccessAllowed = YES; //允许访问iCloud
//    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat; //高质量
//
//    PHAsset * asset;
//    self.imageArray = [[NSMutableArray alloc] initWithArray:self.imageInfoArray];
//    NSDictionary *tmpDic = [self.imageArray objectAtIndex:self.currentIndex];
//
//    NSString * str = tmpDic[@"name"];
//    asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
//
//    CGFloat width = asset.pixelWidth;
//    CGFloat height = asset.pixelHeight;
//    CGFloat scale = width / height;
//    CGFloat tempScale = 1920 / 1080.f;
//    CGSize size;
//    if (scale > tempScale) {
//        size = CGSizeMake(1920, 1920 / scale);
//    }else{
//        size = CGSizeMake(1080 * scale, 1080);
//    }
//    NSString * name = asset.localIdentifier;
//    NSString *nameStr=[name stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//
//        [self compressImageWithImage:result finished:^(NSData *maxData) {
//
////            NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080",[GlobalData shared].boxUrlStr];
//            [ZXTools postImageWithURL:@"" data:maxData name:nameStr sliderName:[self.uploadParams objectForKey:@"sliderName"] progress:^(NSProgress *uploadProgress) {
//
//
//            } success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                NSDictionary *result = (NSDictionary *)responseObject;
//                if ([[result objectForKey:@"result"] integerValue] == 4){
//
//                    self.failedCount = 0;
//                    self.currentIndex++;
//
//                    CGFloat pro = (CGFloat)self.currentIndex / self.imageArray.count * 100.f;
//                    self.percentageLab.text = [NSString stringWithFormat:@"%ld%%", (long)pro];
//                    NSLog(@"进度= %.2f", pro);
//
//                    UIView * tempAlert = [[UIApplication sharedApplication].keyWindow viewWithTag:677];
//                    if (tempAlert) {
//                        [tempAlert removeFromSuperview];
//                    }
//
//                    NSString *infoStr = [result objectForKey:@"info"];
//                    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"抢投提示" message:[NSString stringWithFormat:@"当前%@正在投屏，是否继续投屏?",infoStr]];
//                    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//                        self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
//                    } bold:NO];
//                    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"继续投屏" handler:^{
//                        [self requestNetUpSlideInfoWithForce:1 complete:YES];
//
//                    } bold:NO];
//                    [alertView addActions:@[action,actionOne]];
//                    alertView.tag = 677;
//                    [alertView show];
//
//                }else if([[result objectForKey:@"result"] integerValue] == 0){
//                    self.failedCount = 0;
//                    self.currentIndex++;
//
//                    CGFloat pro = (CGFloat)self.currentIndex / self.imageArray.count * 100.f;
//                    self.percentageLab.text = [NSString stringWithFormat:@"%ld%%", (long)pro];
//                    NSLog(@"进度= %.2f", pro);
//                }else{
//                    self.failedCount++;
//                    if (self.failedCount >= 3) {
//                        self.block([NSError errorWithDomain:@"com.uploadImage" code:202 userInfo:result]);
//                        return;
//                    }
//                }
//
//                [self upLoadImages];
//
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                self.failedCount++;
//                [self upLoadImages];
//
//            }];
//
//        }];
//    }];
}

- (void)compressImageWithImage:(UIImage *)image finished:(void (^)(NSData *))finished
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData*  data = [NSData data];
        data = UIImageJPEGRepresentation(image, 1);
        float tempX = 0.9;
        NSInteger length = data.length;
        while (data.length > 200) {
            data = UIImageJPEGRepresentation(image, tempX);
            tempX -= 0.1;
            if (data.length == length) {
                break;
            }
            length = data.length;
        }
        
        finished(data);
    });
}

@end
