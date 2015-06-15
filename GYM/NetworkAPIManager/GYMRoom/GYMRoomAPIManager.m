//
//  GYMRoomAPIManager.m
//  GYM
//
//  Created by wktzjz on 15/6/10.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "GYMRoomAPIManager.h"

@implementation GYMRoomAPIManager

+ (instancetype)sharedInstance
{
    static GYMRoomAPIManager *sharedInstance = nil;
    
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
    self.methodName = @"picWall";
    return @"picWall";
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


@end
