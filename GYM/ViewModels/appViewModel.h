//
//  appViewModel.h
//  GYM
//
//  Created by wktzjz on 15/6/1.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseViewModel.h"
#import "ViewModelKeys.h"


@interface appViewModel : NSObject

+ (instancetype)sharedInstance;

- (baseViewModel<baseViewModelProtocal> *)viewModelWithIdentifier:(NSString *)identifier;

@end
