//
//  WKCache.m
//  snDataAnalytics
//
//  Created by wktzjz(14081016) on 15-4-8.
//  Copyright (c) 2015年 wktzjz. All rights reserved.
//

#import "WKCache.h"
@import UIKit;
#import <CommonCrypto/CommonDigest.h>

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7 * 52; // 1 year

@implementation WKCache
{
    NSCache          *_memCache;
    NSString         *_diskCachePath;
    NSMutableArray   *_customPaths;
    dispatch_queue_t  _ioQueue;
    NSFileManager    *_fileManager;
}

+ (instancetype)sharedInstance
{
    static WKCache *instance = nil;

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] _init];
    });
    
    return instance;
}

- (instancetype)_init
{
    self = [super init];
    
    if (self) {
       return [self initWithNamespace:@"default_WK"];
    }
    return self;
}

- (id)initWithNamespace:(NSString *)ns
{
    if ((self = [super init])) {
        NSString *fullNamespace = [@"com.suning.WK_wktzjz." stringByAppendingString:ns];
        
        _ioQueue = dispatch_queue_create("com.suning.WK_wktzjz", DISPATCH_QUEUE_SERIAL);
        
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        
        _memCache = [[NSCache alloc] init];
        _memCache.name = fullNamespace;
        
        _diskCachePath = [self makeDiskCachePath:fullNamespace];
        
        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
        
#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
#endif
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    WKDispatchQueueRelease(_ioQueue);
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path
{
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key
{
    return [self cachePathForKey:key inPath:_diskCachePath];
}

#pragma mark WKCache (private)

- (NSString *)cachedFileNameForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

#pragma mark Cache

// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (void)storeData:(id)data nsData:(NSData *)nsData forKey:(NSString *)key toDisk:(BOOL)toDisk protectData:(BOOL)protect
{
    if (!data || !key) {
        return;
    }
    
    [_memCache setObject:data forKey:key];
    
    if (toDisk) {
        dispatch_async(_ioQueue, ^{
            NSData *tempData = nsData;
            
            if (data && !tempData) {
                tempData = [NSKeyedArchiver archivedDataWithRootObject:data];
            }
            
            if (tempData) {
                if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                    [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                
                NSString *path = [self defaultCachePathForKey:key];
                [_fileManager createFileAtPath:path contents:tempData attributes:nil];
                
                if (protect) {
                    NSDictionary *attributes = [NSDictionary
                                                dictionaryWithObject:NSFileProtectionComplete
                                                              forKey:NSFileProtectionKey];
                    
                    [[NSFileManager defaultManager] setAttributes:attributes
                                                     ofItemAtPath:path
                                                            error:nil];
                }
            }
        });
    }
}


- (void)storeData:(id)data forKey:(NSString *)key
{
    [self storeData:data nsData:nil forKey:key toDisk:YES protectData:NO];
}

- (void)storeData:(id)data forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    [self storeData:data nsData:nil forKey:key toDisk:toDisk protectData:NO];
}


- (BOOL)diskDataExistsWithKey:(NSString *)key
{
    BOOL exists = NO;
    
    // this is an exception to access the filemanager on another queue than ioQueue, but we are using the shared instance
    // from apple docs on NSFileManager: The methods of the shared NSFileManager object can be called from multiple threads safely.
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[self defaultCachePathForKey:key]];
    
    return exists;
}

- (void)diskDataExistsWithKey:(NSString *)key completion:(WKCheckCacheCompletionBlock)completionBlock
{
    dispatch_async(_ioQueue, ^{
        BOOL exists = [_fileManager fileExistsAtPath:[self defaultCachePathForKey:key]];
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(exists);
            });
        }
    });
}


- (id)dataFromMemoryCacheForKey:(NSString *)key
{
    return [_memCache objectForKey:key];
}

- (id)dataFromDiskCacheForKey:(NSString *)key
{
    // First check the in-memory cache...
    id data = [self dataFromMemoryCacheForKey:key];
    if (data) {
        return data;
    }
    
    // Second check the disk cache...
    id diskData = [self diskDataForKey:key];
    if (diskData) {
        [_memCache setObject:diskData forKey:key];
    }
    
    return diskData;
}

- (NSData *)diskDataBySearchingAllPathsForKey:(NSString *)key
{
    NSString *defaultPath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }
    
    NSArray *customPaths = [_customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self cachePathForKey:key inPath:path];
        NSData *data1 = [NSData dataWithContentsOfFile:filePath];
        if (data1) {
            return data1;
        }
    }
    
    return nil;
}

- (id)diskDataForKey:(NSString *)key
{
    NSData *data = [self diskDataBySearchingAllPathsForKey:key];
    
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else {
        return nil;
    }
}

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(WKQueryCompletedBlock)doneBlock
{
    if (!doneBlock) {
        return nil;
    }
    
    if (!key) {
        doneBlock(nil, WKCacheTypeNone);
        return nil;
    }
    
    // First check the in-memory cache...
    id data = [self dataFromMemoryCacheForKey:key];
    if (data) {
        doneBlock(data, WKCacheTypeMemory);
        return nil;
    }
    
    NSOperation *operation = [NSOperation new];
    dispatch_async(_ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        @autoreleasepool {
            id diskData = [self diskDataForKey:key];
            if (diskData) {
                [_memCache setObject:diskData forKey:key];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                doneBlock(diskData, WKCacheTypeDisk);
            });
        }
    });
    
    return operation;
}

- (void)removeDataForKey:(NSString *)key {
    [self removeDataForKey:key withCompletion:nil];
}

- (void)removeDataForKey:(NSString *)key withCompletion:(WKNoParamsBlock)completion
{
    [self removeDataForKey:key fromDisk:YES withCompletion:completion];
}

- (void)removeDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    [self removeDataForKey:key fromDisk:fromDisk withCompletion:nil];
}

- (void)removeDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(WKNoParamsBlock)completion
{
    if (key == nil) {
        return;
    }
    
    [_memCache removeObjectForKey:key];
    
    if (fromDisk) {
        dispatch_async(_ioQueue, ^{
            [_fileManager removeItemAtPath:[self defaultCachePathForKey:key] error:nil];
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        });
    } else if (completion){
        completion();
    }
    
}

- (void)clearMemory
{
    [_memCache removeAllObjects];
}

- (void)clearDisk
{
    [self clearDiskOnCompletion:nil];
}

- (void)clearDiskOnCompletion:(WKNoParamsBlock)completion
{
    dispatch_async(_ioQueue, ^{
        [_fileManager removeItemAtPath:_diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:_diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)cleanDisk
{
    [self cleanDiskWithCompletionBlock:nil];
}

- (void)cleanDiskWithCompletionBlock:(WKNoParamsBlock)completionBlock
{
    dispatch_async(_ioQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:_diskCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
}

- (void)backgroundCleanDisk
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}


- (void)calculateSizeWithCompletionBlock:(WKCalculateSizeBlock)completionBlock
{
    NSURL *diskCacheURL = [NSURL fileURLWithPath:_diskCachePath isDirectory:YES];
    
    dispatch_async(_ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}

@end
