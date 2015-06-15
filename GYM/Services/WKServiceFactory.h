//
//  WKServiceFactory.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKService.h"

@interface WKServiceFactory : NSObject

+ (instancetype)sharedInstance;
- (WKService<WKServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;

@end
