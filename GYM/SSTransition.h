//
//  SSTransition.h
//  GYM
//
//  Created by Sara on 15/5/2.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Extension.h"
#import "SSTransitionProtocol.h"
@interface SSTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic)    BOOL presenting;
@end
