//
//  WKTransition.h
//  GYM
//
//  Created by wktzjz on 15/5/27.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Extension.h"
#import "SSTransitionProtocol.h"

typedef void(^startDismissModalViewController)();
typedef void(^finishDismissModalViewController)();

@interface WKTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>

@property (nonatomic) BOOL presenting;
@property (nonatomic) BOOL interacting;

@property (nonatomic,copy) startDismissModalViewController startDismissModalViewControllerBlock;
@property (nonatomic,copy) finishDismissModalViewController finishDismissModalViewControllerBlock;

- (void)startObervesr;
- (void)wireToViewController:(UIViewController *)viewController;
- (void)completePresent;

@end