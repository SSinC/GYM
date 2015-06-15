//
//  WKApiProxy.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKURLResponse.h"

typedef void(^WKNetworkCallback)(WKURLResponse *response);

typedef NS_ENUM (NSUInteger, requestType){
    requestTypeGet,
    requestTypePost,
    requestTypeRestGet,
    requestTypeRestPost
};

@interface WKAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callWithRequestType:(requestType)type withParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(WKNetworkCallback)success fail:(WKNetworkCallback)fail;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(WKNetworkCallback)success fail:(WKNetworkCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(WKNetworkCallback)success fail:(WKNetworkCallback)fail;

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(WKNetworkCallback)success fail:(WKNetworkCallback)fail;
- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(WKNetworkCallback)success fail:(WKNetworkCallback)fail;

- (NSInteger)callGoogleMapAPIWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier success:(WKNetworkCallback)success fail:(WKNetworkCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
