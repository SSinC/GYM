//
//  WKService.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 所有WKService的派生类都要符合这个protocal
@protocol WKServiceProtocal <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@property (nonatomic, readonly) NSString *onlinePublicKey;
@property (nonatomic, readonly) NSString *offlinePublicKey;

@property (nonatomic, readonly) NSString *onlinePrivateKey;
@property (nonatomic, readonly) NSString *offlinePrivateKey;

@end

@interface WKService : NSObject

@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) NSString *apiBaseUrl;
@property (nonatomic, strong) NSString *apiVersion;

@property (nonatomic, weak) id<WKServiceProtocal> child;

@end
