//
//  NSDictionary+WKNetworkingMethods.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WKNetworkingMethods)

- (NSString *)WK_urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)WK_jsonString;
- (NSArray *)WK_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
