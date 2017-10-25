//
//  GCCDLNA.m
//  DLNATest
//
//  Created by 郭春城 on 16/10/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GCCDLNA.h"
#import "GCDAsyncUdpSocket.h"
#import "HSGetIpRequest.h"

static NSString *ssdpForPlatform = @"238.255.255.250"; //监听小平台ssdp地址

static UInt16 platformPort = 11900; //监听小平台ssdp端口

@interface GCCDLNA ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket * socket;
@property (nonatomic, assign) BOOL isSearchPlatform;

@property (nonatomic, assign) NSInteger hotelId_Box; //盒子获取的酒楼ID

@end

@implementation GCCDLNA

+ (GCCDLNA *)defaultManager
{
    static dispatch_once_t once;
    static GCCDLNA *manager;
    dispatch_once(&once, ^ {
        manager = [[GCCDLNA alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.hotelId_Box = 0;
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.isSearchPlatform = NO;
    }
    return self;
}

//配置小平台设备搜索的socket相关端口信息
- (void)setUpSocketForPlatform
{
    NSError *error = nil;
    if (![self.socket bindToPort:platformPort error:&error])
    {
        NSLog(@"Error binding: %@", error);
    }
    if (![self.socket joinMulticastGroup:ssdpForPlatform error:&error])
    {
        NSLog(@"Error join: %@", error);
    }
    if (![self.socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
    }
}

- (void)startSearchPlatform
{
    if (self.isSearch) {
        [self resetSearch];
    }
    
    self.isSearch = YES;
    
    if (!self.socket.isClosed) {
        [self.socket close]; //先关闭当前的socket连接
    }
    [self setUpSocketForPlatform]; //若当前socket处于关闭状态，先配置socket地址和端口
    [self getIP];
    self.isSearchPlatform = YES;
    [self performSelector:@selector(stopSearchDevice) withObject:nil afterDelay:10.f];
}

- (void)getIP
{
    HSGetIpRequest * request = [[HSGetIpRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

//停止设备搜索
- (void)stopSearchDevice
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
    
    if (!self.socket.isClosed) {
        [self.socket close]; //调用socket关闭
    }
    
    self.isSearch = NO;
}

- (void)stopSearchDeviceWithNetWorkChange
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
    
    if (!self.socket.isClosed) {
        [self.socket close]; //调用socket关闭
    }
    
    self.isSearch = NO;
}

- (void)resetSearch
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
}

//获取到设备反馈信息
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    
    if (self.isSearchPlatform) {
        [self getPlatformHeadURLWith:data];
    }
}

//解析从小平台获取的SSDP的discover信息
- (void)getPlatformHeadURLWith:(NSData *)data
{
//    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    NSArray * array = [str componentsSeparatedByString:@"\n"];
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//
//    for (NSString * infoStr in array) {
//        NSArray * dictArray = [infoStr componentsSeparatedByString:@":"];
//        if (dictArray.count == 2) {
//            [dict setObject:[dictArray objectAtIndex:1] forKey:[dictArray objectAtIndex:0]];
//        }
//    }
//
//    NSString * host = [dict objectForKey:@"Savor-HOST"];
//    NSString * boxHost = [dict objectForKey:@"Savor-Box-HOST"];
//    if (host.length || boxHost.length) {
//
//        if ([[dict objectForKey:@"Savor-Type"] isEqualToString:@"box"]) {
//
//
//            }else{
//
//            }
//
//            self.hotelId_Box = [[dict objectForKey:@"Savor-Hotel-ID"] integerValue];
//            self.isSearch = NO;
//        }else{
//
//            self.isSearch = NO;
//        }
//    }
}

- (void)dealloc
{
    
}

@end