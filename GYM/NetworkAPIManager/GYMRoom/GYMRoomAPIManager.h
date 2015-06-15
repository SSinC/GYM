//
//  GYMRoomAPIManager.h
//  GYM
//
//  Created by wktzjz on 15/6/10.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIBaseManager.h"

@interface GYMRoomAPIManager : APIBaseManager <APIManager>

+ (instancetype)sharedInstance;

@end
