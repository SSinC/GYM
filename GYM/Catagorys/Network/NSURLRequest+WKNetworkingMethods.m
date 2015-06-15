//
//  NSURLRequest+WKNetworkingMethods.m
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "NSURLRequest+WKNetworkingMethods.h"
#import <objc/runtime.h>

static void *WKNetworkingRequestParams;

@implementation NSURLRequest (WKNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &WKNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &WKNetworkingRequestParams);
}

@end
