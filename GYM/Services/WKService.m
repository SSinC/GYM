//
//  WKService.m
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "WKService.h"

@implementation WKService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(WKServiceProtocal)]) {
            self.child = (id<WKServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - getters and setters
//- (NSString *)privateKey
//{
//    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
//}
//
//- (NSString *)publicKey
//{
//    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
//}
//
//- (NSString *)apiBaseUrl
//{
//    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
//}
//
//- (NSString *)apiVersion
//{
//    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
//}

@end
