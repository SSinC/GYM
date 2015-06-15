//
//  WKRequestGenerator.m
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "WKRequestGenerator.h"
#import "WKSignatureGenerator.h"
#import "WKServiceFactory.h"
#import "WKCommonParamsGenerator.h"
#import "WKNetworkingConfiguration.h"
#import "AFNetworking.h"
#import "WKService.h"
#import "NSDictionary+WKNetworkingMethods.h"
//#import "NSObject+WKNetworkingMethods.h"
#import "NSURLRequest+WKNetworkingMethods.h"

@interface WKRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation WKRequestGenerator

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kWKNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static WKRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    WKService *service = [[WKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    NSString *urlString;
    
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
    sigParams[@"api_key"] = service.publicKey;
    NSString *signature = [WKSignatureGenerator signGetWithSigParams:sigParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey publicKey:service.publicKey];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[WKCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:sigParams];
//    urlString = [NSString stringWithFormat:@"%@%@/%@?%@&sig=%@", service.apiBaseUrl, service.apiVersion, methodName, [allParams WK_urlParamsStringSignature:NO],signature];
    urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];

    //http://123.57.210.197:8080/yundong/meitu/meitu-info/get-meitu-list
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.timeoutInterval = kWKNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    WKService *service = [[WKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [WKSignatureGenerator signPostWithApiParams:requestParams privateKey:service.privateKey publicKey:service.publicKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?api_key=%@&sig=%@&%@", service.apiBaseUrl, service.apiVersion, methodName, service.publicKey, signature, [[WKCommonParamsGenerator commonParamsDictionary] WK_urlParamsStringSignature:NO]];
    
    NSURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateRestfulGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[WKCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    
    WKService *service = [[WKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [WKSignatureGenerator signRestfulGetWithAllParams:allParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@", service.apiBaseUrl, service.apiVersion, methodName, [allParams WK_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kWKNetworkingTimeoutSeconds];
    request.HTTPMethod = @"GET";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateRestfulPOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    WKService *service = [[WKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSDictionary *commonParams = [WKCommonParamsGenerator commonParamsDictionary];
    NSString *signature = [WKSignatureGenerator signRestfulPOSTWithApiParams:requestParams commonParams:commonParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?&%@", service.apiBaseUrl, service.apiVersion, methodName, [commonParams WK_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kWKNetworkingTimeoutSeconds];
    request.HTTPMethod = @"POST";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateGoolgeMapAPIRequestWithParams:(NSDictionary *)requestParams serviceIdentifier:(NSString *)serviceIdentifier
{
    WKService *service = [[WKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *paramsString = [requestParams WK_urlParamsStringSignature:NO];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@", service.apiBaseUrl, service.apiVersion, paramsString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kWKNetworkingTimeoutSeconds];
    [request setValue:@"zh-CN,zh;q=0.8,en;q=0.6" forHTTPHeaderField:@"Accept-Language"];
    request.requestParams = requestParams;
    return request;
}

#pragma mark - private methods
- (NSDictionary *)commRESTHeadersWithService:(WKService *)service signature:(NSString *)signature
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:signature forKey:@"sig"];
    [headerDic setValue:service.publicKey forKey:@"key"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"______"];
    if (loginResult[@"auth_token"]) {
        [headerDic setValue:loginResult[@"auth_token"] forKey:@"AuthToken"];
    }
    return headerDic;
}

@end
