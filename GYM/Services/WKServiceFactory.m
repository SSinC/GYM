//
//  WKServiceFactory.m
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "WKServiceFactory.h"
#import "WKService.h"
#import "PicWallService.h"


/*************************************************************************/

NSString * const kServicePicWall = @"kServicePicWall";



@interface WKServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation WKServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static WKServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (WKService<WKServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier
{
    if (!identifier) return nil;
    
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (WKService<WKServiceProtocal> *)newServiceWithIdentifier:(NSString *)identifier
{
    // picWall
    if ([identifier isEqualToString:kServicePicWall]) {
        return [[PicWallService alloc] init];
    }
    
    return nil;
}

@end
