//
//  appViewModel.m
//  GYM
//
//  Created by wktzjz on 15/6/1.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "appViewModel.h"
#import "picWallViewModel.h"

@implementation appViewModel
{
    NSMutableDictionary *_modelStorage;
}

+ (instancetype)sharedInstance
{
    static appViewModel *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
         _modelStorage = [[NSMutableDictionary alloc] init];
        //        [self startNotification];
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

- (instancetype)new
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

#pragma mark - public methods
- (baseViewModel<baseViewModelProtocal> *)viewModelWithIdentifier:(NSString *)identifier
{
    if (_modelStorage[identifier] == nil) {
        _modelStorage[identifier] = [self newViewModelWithIdentifier:identifier];
    }
    return _modelStorage[identifier];
}


#pragma mark - private methods
- (baseViewModel<baseViewModelProtocal> *)newViewModelWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:viewModelTestKey]) {
        return [[picWallViewModel alloc] init];
    }
    
    return nil;
}


@end
