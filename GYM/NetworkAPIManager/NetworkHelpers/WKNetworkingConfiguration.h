//
//  WKNetworkingConfiguration.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#ifndef WKNetworking_WKNetworkingConfiguration_h
#define WKNetworking_WKNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, WKAppType) {
    WKAppTypeGYM,
};

typedef NS_ENUM(NSUInteger, WKURLResponseStatus)
{
    WKURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的APIBaseManager来决定。
    WKURLResponseStatusErrorTimeout,
    WKURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kWKNetworkingTimeoutSeconds = 20.0f;

static NSString *WKKeychainServiceName = @"com.wkGYMApps";
static NSString *WKUDIDName = @"wkGYMUDID";
static NSString *WKPasteboardType = @"wkGYMAppsContent";

static BOOL kWKShouldCache = YES;
static NSTimeInterval kWKCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kWKCacheCountLimit = 1000; // 最多1000条cache

// picWall
extern NSString * const kWKServicePicWall;

#endif
