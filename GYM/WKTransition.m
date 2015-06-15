//
//  WKTransition.m
//  GYM
//
//  Created by wktzjz on 15/5/27.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "WKTransition.h"
#import "UIView+snapShot.h"
#import "UIViewController+clickedViewIndex.h"
#import "Macro.h"
#import "GYMTabBarController.h"
//#import "POP.h"


#define navigationBarHeight 44.0

static CGFloat animationDuration = 0.35;
static CGFloat targetWidth  = 132.;
static CGFloat targetHeight = 180.;


@implementation WKTransition
{
    id<UIViewControllerContextTransitioning> _presentTransitionContext;
    UIView *_toView;
    UIView *_snapShot;
    UIView *_whiteViewContainer;
    
    BOOL _shouldComplete;
    CGFloat _percentComplete;
    id<UIViewControllerContextTransitioning> _transitionContext;
    
    CAShapeLayer *_maskLayer;

}

- (void)startObervesr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(completePresent)
                                                     name:@"dataDidInitialize" object:nil];
    });
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _presentTransitionContext = transitionContext;
//    CGFloat animationScale = ([UIScreen mainScreen].bounds.size.width)/gridWidth ;
//    CGFloat original = ([UIScreen mainScreen].bounds.size.width - 10.0) / 2.0 ;
//    CGFloat scale = [UIScreen mainScreen].bounds.size.width / original;//sara
    GYMTabBarController *fromViewController = (GYMTabBarController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (_presenting) {
        _toView = toViewController.view;
        [containerView addSubview:_toView];
        _toView.hidden = YES;
        
//        UICollectionView *waterFallView = nil;
//        if ([toViewController respondsToSelector:@selector(transitionCollectionView)]) {
//            waterFallView = [(id<SSTransitionProtocol>)toViewController transitionCollectionView];
//        }
//        UICollectionView *pageView = [(id<SSTransitionProtocol>)fromViewController transitionCollectionView];
//        [waterFallView setNeedsLayout];
//        NSIndexPath *indexpath = [pageView fromPageIndexPath];
//        UICollectionViewCell *gridView = [waterFallView cellForItemAtIndexPath:indexpath];
//        CGPoint leftUpperPoint = [gridView convertPoint:CGPointZero toView:nil];
//        
//        UIView *snapShot = [(id<SSTansitionWaterfallGridViewProtocol>)gridView snapShotForTransition];
//        snapShot.transform = CGAffineTransformMakeScale(scale, scale);
//        CGFloat pullOffsetY = [(id<SSHorizontalPageViewControllerProtocol>)fromViewController  pageViewCellScrollViewContentOffset].y;
//        CGFloat offsetY = fromViewController.navigationController.navigationBarHidden ? 0.0 : navigationHeaderAndStatusbarHeight;
//        
//        CGRect rc = snapShot.frame;
//        rc.origin.x = 0;
//        rc.origin.y = -pullOffsetY+offsetY;
//        snapShot.frame = rc;
        
        UIView *clickedOutlineView = (UIView *)[fromViewController.viewControllers[2] clickedView];
        //        NSLog(@"fromViewController:%@",fromViewController);
        //         NSLog(@"fromViewController.clickedView:%@",fromViewController.clickedView);
//        UIView *snapShot;
        /* get the imageSnapshot View of the clicked View */
        if (clickedOutlineView) {
            _snapShot = [[UIImageView alloc] initWithImage:[clickedOutlineView snapshot]];
            _snapShot.layer.cornerRadius = 10.0;
            
            /* set the snapshot view frame as the clicked outlineView is in mainView */
            NSArray *arrayOfFrame = (NSArray *)[fromViewController.viewControllers[2] clickedViewFrame];
            CGRect snapInitialFrame = CGRectMake( ((NSNumber *)arrayOfFrame[0]).floatValue, ((NSNumber *)arrayOfFrame[1]).floatValue,((NSNumber *)arrayOfFrame[2]).floatValue, ((NSNumber *)arrayOfFrame[3]).floatValue );
            [_snapShot setFrame:snapInitialFrame];
            
//            snapShot.layer.shadowOpacity = 0.5;
//            snapShot.layer.shadowRadius  = 10;
//            snapShot.layer.shadowColor   = [UIColor blackColor].CGColor;
//            snapShot.layer.shadowOffset  = CGSizeMake(-3, 3);
            
            [containerView addSubview:_snapShot];
        }
        
        _toView.hidden = false;
        _toView.alpha = 0;
//        toView.transform = snapShot.transform;
//        toView.frame = CGRectMake(-(leftUpperPoint.x * scale),-((leftUpperPoint.y-offsetY) * scale+pullOffsetY+offsetY), toView.frame.size.width, toView.frame.size.height);
        _whiteViewContainer = [[UIView alloc] initWithFrame: screenBounds];
        _whiteViewContainer.backgroundColor = [UIColor whiteColor];
        [containerView insertSubview:_whiteViewContainer belowSubview:_toView];
        
        CGPoint targetCenter = CGPointMake(100 + targetWidth / 2.0, 100 + targetHeight / 2.0);
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             _snapShot.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             
                             _snapShot.layer.shadowOpacity = 0.5;
                             _snapShot.layer.shadowRadius  = 10;
                             _snapShot.layer.shadowColor   = [UIColor blackColor].CGColor;
                             _snapShot.layer.shadowOffset  = CGSizeMake(-3, 3);
//                             toView.alpha = 1;
                         } completion:^(BOOL finished) {

                             [UIView animateWithDuration:0.7
                                                   delay:0.0
                                  usingSpringWithDamping:0.8
                                   initialSpringVelocity:0.5
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  _snapShot.center = targetCenter;
                                              }completion:^(BOOL finished) {}
                              ];

                         }];
        
    }else{
        
        if (_interacting) return;
        
        // 1. Get controllers from transition context
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        toVC.view.userInteractionEnabled = YES;
        
        CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
        CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
        
        CGRect originalToViewFrame = toVC.view.frame;
        CGRect r = toVC.view.frame;
        toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            //        fromVC.view.alpha = 0.0;
            fromVC.view.frame = finalFrame;
            toVC.view.frame = originalToViewFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    }
    
}

- (void)completePresent
{
    NSLog(@"in completePresent");
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _snapShot.transform = CGAffineTransformIdentity;
                         _toView.transform = CGAffineTransformIdentity;
                         _toView.frame = CGRectMake(0, 0, _toView.frame.size.width, _toView.frame.size.height);
//                         _toView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             __strong __typeof(weakSelf) strongSelf = weakSelf;
                             
                             _toView.alpha = 1;
                             
                             CGRect startFrame = CGRectMake(100, 100, 132, 180);
                             _maskLayer = [[CAShapeLayer alloc] init];
                             CGRect maskRect = startFrame;
                             
                             CGPathRef path = CGPathCreateWithEllipseInRect(maskRect, NULL);
                             _maskLayer.path = path;
                             
                             float d = sqrtf(powf(_toView.frame.size.width, 2)+powf(startFrame.size.height, 2));
                             d *= 2;
                             CGRect newR=  CGRectMake(_toView.frame.size.width/2-d/2 ,maskRect.origin.y-d/2, d, d);
                             CGPathRef newPath = CGPathCreateWithEllipseInRect(newR, NULL);
                             
                             _toView.layer.mask = _maskLayer;

                             CABasicAnimation* revealAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
                             revealAnimation.delegate = strongSelf;
                             revealAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                             revealAnimation.fromValue = (__bridge id)(path);
//                             revealAnimation.toValue = (__bridge id)(newPath);
                             revealAnimation.duration = 0.3;
                             
                             _maskLayer.path = newPath;
                             CGPathRelease(path);
                             
                             [_maskLayer addAnimation:revealAnimation forKey:@"circleAnimation"];

                         }
                     }];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_maskLayer removeFromSuperlayer];
    [_snapShot removeFromSuperview];
    [_whiteViewContainer removeFromSuperview];
    [_presentTransitionContext completeTransition:YES];
}


-(void)wireToViewController:(UIViewController *)viewController
{
//    _presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view
{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _interacting = YES;
            if (_startDismissModalViewControllerBlock) {
                _startDismissModalViewControllerBlock();
            }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = translation.x / 300.0;
            //Limit it between 0 and 1
            fraction = fminf(fraction, 1.0);
            _percentComplete += fraction;
            _shouldComplete = (_percentComplete > 0.4);
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (!_shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
                if (_finishDismissModalViewControllerBlock){
                    _finishDismissModalViewControllerBlock();
                }
            }
            
            _interacting = NO;
            break;
        }
        default:
            break;
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    _percentComplete = 0.0;
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.userInteractionEnabled = YES;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect originalToViewFrame = toVC.view.frame;
    toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
    
    UIView *containerView = [transitionContext containerView];
    [containerView bringSubviewToFront:fromVC.view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (_percentComplete < 0) return;
    
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGPoint center = fromViewController.view.center;
    
    center = CGPointMake(center.x + percentComplete * screenBounds.size.width, center.y);
    fromViewController.view.center = center;
    
    center = toViewController.view.center;
    center = CGPointMake(center.x + percentComplete * 200, center.y);
    toViewController.view.center = center;
//    NSLog(@"toVC.view.frame:%@",NSStringFromCGRect(toViewController.view.frame));

}

- (void)finishInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for fromVC
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        //        fromVC.view.alpha = 0.0;
        fromVC.view.frame = finalFrame;
        toVC.view.frame = screenBounds;
    } completion:^(BOOL finished) {
        [[[UIApplication sharedApplication] keyWindow] sendSubviewToBack:toVC.view];
        [transitionContext completeTransition:YES];
    }];
    
}

- (void)cancelInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
    
    CGRect originalToViewFrame = toVC.view.frame;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
        //        fromVC.view.alpha = 0.0;
        fromVC.view.frame = initFrame;
        toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
    }                completion:^(BOOL finished) {
        [transitionContext completeTransition:NO];
    }];
    
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _presenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _presenting = NO;
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interacting ? self : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

@end
