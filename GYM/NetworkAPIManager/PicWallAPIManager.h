//
//  PicWallAPIManager.h
//  GYM
//
//  Created by wktzjz on 15/6/5.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIBaseManager.h"

@interface PicWallAPIManager : APIBaseManager <APIManager>

+ (instancetype)sharedInstance;

@end
