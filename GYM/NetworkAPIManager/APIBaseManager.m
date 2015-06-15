//
//  APIBaseManager.m
//  WKNetworking
//
//  Created by wktzjz on 15/6/4.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "APIBaseManager.h"
#import "WKAppContext.h"
#import "WKAPIProxy.h"

@implementation APIBaseManager
{
    NSMutableArray *_requestIdList;
    
    APIManagerErrorType _errorType;
    NSString *_errorMessage;
    
}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        
        _fetchedData = nil;
        
        _errorMessage = nil;
        _errorType = APIManagerErrorTypeDefault;
        
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    _requestIdList = nil;
}


#pragma mark - public methods

- (NSInteger)getNetworkDataWithParams:(NSDictionary *)params
{
    // 先检查一下是否有缓存
    if ([self hasCacheWithParams:params]) {
        return 0;
    }
    
    // 实际的网络请求
    if ([self isReachable]) {
        
        NSInteger REQUEST_ID = [[WKAPIProxy sharedInstance] callWithRequestType:(requestType)_requestType withParams:params serviceIdentifier:self.serviceType methodName:self.methodName success:^(WKURLResponse *response) {
            [self successedOnCallingAPI:response];
        } fail:^(WKURLResponse *response) {
            [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];
        }];
        [self.requestIdList addObject:@(REQUEST_ID)];
        
        return REQUEST_ID;
    }
    
    return 0;
}


- (void)cancelAllRequests
{
    [[WKAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[WKAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

//- (id)fetchDataWithReformer:(id<APIManagerCallbackDataReformer>)reformer
//{
//    id resultData = nil;
//    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
//        resultData = [reformer manager:self reformData:_fetchedData];
//    } else {
//        resultData = [_fetchedData mutableCopy];
//    }
//    return resultData;
//}


#pragma mark - network Call Back API

- (void)successedOnCallingAPI:(WKURLResponse *)response
{
    if (response.content) {
        _fetchedData = [response.content copy];
    } else {
        _fetchedData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (!response.isCache) {
        // cache return data
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]){
        [self.delegate managerCallAPIDidSuccess:self];
    }
    
}

- (void)failedOnCallingAPI:(WKURLResponse *)response withErrorType:(APIManagerErrorType)errorType
{
    _errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]){
        [self.delegate managerCallAPIDidFailed:self];
    }
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
    
- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = _serviceType;
    NSString *methodName = _methodName;

    return NO;
}


#pragma mark - getters and setters

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [WKAppContext sharedInstance].isReachable;
    if (!isReachability) {
        _errorType = APIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    return [self.requestIdList count] > 0;
}
    
@end
