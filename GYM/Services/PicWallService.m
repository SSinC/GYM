//
//  PicWallService.m
//  GYM
//
//  Created by wktzjz on 15/6/5.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "PicWallService.h"

@implementation PicWallService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.publicKey = @"";
        self.privateKey = @"";
        self.apiBaseUrl  = @"http://123.57.210.197:8080/yundong/";
        self.apiVersion= @"";
    }
    
    return self;
}

@end
