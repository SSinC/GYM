//
//  SSTransition.m
//  GYM
//
//  Created by Sara on 15/5/2.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSTransition.h"
#import "Macro.h"

@interface SSTransition()
{
    
}
@end

static CGFloat animationDuration = 0.35;

@implementation SSTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    CGFloat animationScale = ([UIScreen mainScreen].bounds.size.width)/gridWidth ;
    CGFloat original = ([UIScreen mainScreen].bounds.size.width - 10.0) / 2.0 ;
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / original;//sara
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (_presenting) {
        UIView *toView = toViewController.view;
        [containerView addSubview:toView];
        toView.hidden = YES;
        
        UICollectionView *waterFallView = nil;
        if ([toViewController respondsToSelector:@selector(transitionCollectionView)]) {
            waterFallView = [(id<SSTransitionProtocol>)toViewController transitionCollectionView];
        }
        [waterFallView setNeedsLayout];
        
        //sara
        //  UICollectionView *pageView = [(id<SSTransitionProtocol>)fromViewController transitionCollectionView];
        //  NSIndexPath *indexpath = [pageView fromPageIndexPath];
        
        NSIndexPath *indexpath = [(id<SSTransitionProtocol>)fromViewController currentIndexpath];//sara
        UICollectionViewCell *gridView = [waterFallView cellForItemAtIndexPath:indexpath];
        CGPoint leftUpperPoint = [gridView convertPoint:CGPointZero toView:nil];
        
        UIView *snapShot = [(id<SSTansitionWaterfallGridViewProtocol>)gridView snapShotForTransition];
        snapShot.transform = CGAffineTransformMakeScale(scale, scale);
        CGFloat pullOffsetY = [(id<SSHorizontalPageViewControllerProtocol>)fromViewController  pageViewCellScrollViewContentOffset].y;
        //     CGFloat offsetY = fromViewController.navigationController.navigationBarHidden ? 0.0 : navigationHeaderAndStatusbarHeight;
        // sara
        CGFloat offsetY = fromViewController.navigationController.myNavigationbar.hidden ? 0.0 : navigationHeaderAndStatusbarHeight;    //
        
        CGRect rc = snapShot.frame;
        rc.origin.x = 0;
        rc.origin.y = -pullOffsetY+offsetY;
        snapShot.frame = rc;
        [containerView addSubview:snapShot];
        
        toView.hidden = false;
        toView.alpha = 0;
        toView.transform = snapShot.transform;
        toView.frame = CGRectMake(-(leftUpperPoint.x * scale),-((leftUpperPoint.y-offsetY) * scale+pullOffsetY+offsetY), toView.frame.size.width, toView.frame.size.height);
        UIView* whiteViewContainer = [[UIView alloc] initWithFrame: screenBounds];
        whiteViewContainer.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:snapShot];
        [containerView insertSubview:whiteViewContainer belowSubview:toView];
        [UIView animateWithDuration:animationDuration animations:^{
            snapShot.transform = CGAffineTransformIdentity;
            snapShot.frame = CGRectMake(leftUpperPoint.x, leftUpperPoint.y, snapShot.frame.size.width, snapShot.frame.size.height);
            toView.transform = CGAffineTransformIdentity;
            toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
            toView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                [snapShot removeFromSuperview];
                [whiteViewContainer removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
        
        
        
    }else{
        UIView* fromView = fromViewController.view;
        UIView* toView = toViewController.view;
        
        UICollectionView* waterFallView = [(id<SSTransitionProtocol>)fromViewController transitionCollectionView];
        //  UICollectionView* pageView  = [(id<SSTransitionProtocol>)toViewController transitionCollectionView];
        UITableView* pageView  = [(id<SSTransitionProtocol>)toViewController transitionTableView];
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        
        NSIndexPath* indexPath = [waterFallView toIndexPath];
        UICollectionViewCell* gridView = [waterFallView cellForItemAtIndexPath:indexPath];
        
        CGPoint leftUpperPoint = [gridView convertPoint:CGPointZero toView:nil];
        pageView.hidden = YES;
        //   [ pageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated: NO];
        
        //sara
        CGFloat offsetY = fromViewController.navigationController.myNavigationbar.hidden ? 0.0 : navigationHeaderAndStatusbarHeight;    //
        CGFloat offsetStatuBar = fromViewController.navigationController.myNavigationbar.hidden ? 0.0 : statubarHeight;
        
        //sara  delete      CGFloat offsetY = fromViewController.navigationController.navigationBarHidden ? 0.0 : navigationHeaderAndStatusbarHeight;
        //sara   delete     CGFloat offsetStatuBar = fromViewController.navigationController.navigationBarHidden ? 0.0 :
        //        statubarHeight;
        UIView* snapShot = [(id<SSTansitionWaterfallGridViewProtocol>)gridView snapShotForTransition];
        [containerView addSubview:snapShot];
        [snapShot origin:leftUpperPoint];
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            snapShot.transform = CGAffineTransformMakeScale(scale,scale);
            snapShot.frame = CGRectMake(0, offsetY, snapShot.frame.size.width, snapShot.frame.size.height);
            
            fromView.alpha = 0;
            fromView.transform = snapShot.transform;
            fromView.frame = CGRectMake(-(leftUpperPoint.x)*scale,
                                        -(leftUpperPoint.y-offsetStatuBar)*scale+offsetStatuBar,
                                        fromView.frame.size.width,
                                        fromView.frame.size.height);
        } completion:^(BOOL finished) {
            if (finished)
            {
                [snapShot removeFromSuperview];
                pageView.hidden = NO;
                fromView.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:YES];
                
                
            }
            
        }];
    }
    
}

@end
