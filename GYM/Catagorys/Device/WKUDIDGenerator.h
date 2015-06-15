//
//  WKUDIDGenerator.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKUDIDGenerator : NSObject

+ (id)sharedInstance;

- (NSString *)UDID;
- (void)saveUDID:(NSString *)udid;

@end
