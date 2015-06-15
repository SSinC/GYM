//
//  SSWaterfallViewController.h
//  GYM
//
//  Created by Sara on 15/4/30.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTransition.h"
#import "Extension.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "SSHorizontalPageViewController.h"
#import "SSphotoDetailTableViewVC.h"
#import "picWallViewModel.h"


@interface SSWaterfallViewController : UICollectionViewController<CHTCollectionViewDelegateWaterfallLayout, SSTransitionProtocol, SSWaterFallViewControllerProtocol>

@property(nonatomic,copy)  NSMutableArray *imageNameList;
@property(nonatomic,copy)  NSMutableArray *smallImageURLList;
@property(nonatomic,copy)  NSMutableArray *bigImageURLList;



- (instancetype)initWithViewModel:(picWallViewModel *)model WithCollectionViewLayout:(UICollectionViewLayout *)layout;

@end
