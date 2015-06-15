//
//  SSHorizontalPageViewController.h
//  GYM
//
//  Created by Sara on 15/5/14.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTransitionProtocol.h"
@interface SSHorizontalPageViewController : UICollectionViewController < SSTransitionProtocol,SSHorizontalPageViewControllerProtocol>
@property(nonatomic,copy)  NSArray * imageNameList;
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout currentIndexPath:(NSIndexPath*)indexpath;

@end
