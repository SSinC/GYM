//
//  testViewController2.h
//  GYM
//
//  Created by wktzjz on 15/5/28.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "picWallViewModel.h"
#import "APIBaseManager.h"
#import "WKTransition.h"

@interface testViewController2 : UIViewController <APIManagerApiCallBackDelegate>

@property(nonatomic, strong) WKTransition *animator;

- (instancetype)initWithViewModel:(picWallViewModel *)model;

@end
