//
//  WKCache.h
//  snDataAnalytics
//
//  Created by wktzjz(14081016) on 15-4-8.
//  Copyright (c) 2015年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKDefine.h"

typedef NS_ENUM(NSInteger, DataCacheType)
{
    WKCacheTypeNone,
    WKCacheTypeDisk,
    WKCacheTypeMemory
};

typedef void(^WKQueryCompletedBlock)(id data, DataCacheType cacheType);
typedef void(^WKCheckCacheCompletionBlock)(BOOL isInCache);
typedef void(^WKCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);


@interface WKCache : NSObject

@property (assign, nonatomic) NSInteger maxCacheAge;

+ (instancetype)sharedInstance;
- (id)initWithNamespace:(NSString *)ns;
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace;

//store
- (void)storeData:(id)data forKey:(NSString *)key;
- (void)storeData:(id)data forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeData:(id)data nsData:(NSData *)nsData forKey:(NSString *)key toDisk:(BOOL)toDisk protectData:(BOOL)protect;

//Query Data synchronously
- (id)dataFromMemoryCacheForKey:(NSString *)key;
- (id)dataFromDiskCacheForKey:(NSString *)key;
//Query the disk cache asynchronously.
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(WKQueryCompletedBlock)doneBlock;

//remove
- (void)removeDataForKey:(NSString *)key;
- (void)removeDataForKey:(NSString *)key withCompletion:(WKNoParamsBlock)completion;
- (void)removeDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (void)removeDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(WKNoParamsBlock)completion;

//clean
- (void)clearMemory;
- (void)clearDiskOnCompletion:(WKNoParamsBlock)completion;
- (void)clearDisk;
- (void)cleanDiskWithCompletionBlock:(WKNoParamsBlock)completionBlock;
- (void)cleanDisk;

- (void)calculateSizeWithCompletionBlock:(WKCalculateSizeBlock)completionBlock;

- (void)diskImageExistsWithKey:(NSString *)key completion:(WKCheckCacheCompletionBlock)completionBlock;
- (BOOL)diskImageExistsWithKey:(NSString *)key;

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;
- (NSString *)defaultCachePathForKey:(NSString *)key;


@end
