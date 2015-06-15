//
//  SSNavigationController.m
//  GYM
//
//  Created by Sara on 15/5/14.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSNavigationController.h"
#import "SSTransitionProtocol.h"
#import "Extension.h"

@interface SSNavigationController ()
@end


@implementation SSNavigationController

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//  //  viewController.hidesBottomBarWhenPushed = YES;
//    [super pushViewController:viewController animated:animated];
//}

//- (UIViewController*)popViewControllerAnimated:(BOOL)animated
//{
//    //viewWillAppearWithPageIndex
//    NSInteger childrenCount = self.viewControllers.count;
//    UIViewController* toViewController = self.viewControllers[childrenCount-2] ;
//    UICollectionView* toView = [(id<SSWaterFallViewControllerProtocol>)toViewController transitionCollectionView];
//    UICollectionViewController* popedViewController = self.viewControllers[childrenCount-1] ;
//    UICollectionView* popView  = popedViewController.collectionView;
//    NSIndexPath* indexPath = [popView fromPageIndexPath ];
//    [(id<SSWaterFallViewControllerProtocol>)toViewController viewWillAppearWithPageIndex:indexPath.row];
//    [toView setToIndexPath:indexPath];
//    
//    return [super popViewControllerAnimated:animated];
//
//}

//- (void)awakeFromNib
//{
//    self.hidesBarsOnSwipe = YES;
// 
//}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        [self setNavigationBarHidden:YES animated:YES];
        
        _navigationbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        _navigationbar.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:0.6];
        [self.view addSubview:_navigationbar];
        self.myNavigationbar = _navigationbar;
        _navigationbar.hidden = NO;

    }
    return self;
}




@end

