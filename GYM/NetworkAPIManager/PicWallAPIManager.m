//
//  PicWallAPIManager.m
//  GYM
//
//  Created by wktzjz on 15/6/5.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "PicWallAPIManager.h"

@implementation PicWallAPIManager

#pragma mark - init

+ (instancetype)sharedInstance
{
    static PicWallAPIManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
//        [self startNotification];
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

- (instancetype)new
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

- (NSString *)methodName
{
    self.methodName = @"meitu/meitu-info/get-meitu-list";
    return @"meitu/meitu-info/get-meitu-list";
}

- (NSString *)serviceType
{
    self.serviceType = @"kServicePicWall";
    return @"kServicePicWall";
}

- (APIManagerRequestType)requestType
{
    self.requestType = APIManagerRequestTypeGet;
    return APIManagerRequestTypeGet;
}

- (void)startNotification
{
    NSLog(@"startNotification");
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    //    __weak __typeof(self) weakself = self;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataDidInitialize" object:self userInfo:nil];
    });
}


//#pragma mark - RTAPIManagerApiCallBackDelegate
//- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
//{
//    [self startNotification];
//}
//
//- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
//{
//    //留给将来使用API的时候用
//}


@end
