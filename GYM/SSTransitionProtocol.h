//
//  SSTransitionProtocol.h
//  GYM
//
//  Created by Sara on 15/5/2.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#ifndef GYM_SSTransitionProtocol_h
#define GYM_SSTransitionProtocol_h


@protocol SSTransitionProtocol <NSObject>
@optional
- (UICollectionView*)transitionCollectionView;
- (NSIndexPath*)currentIndexpath;
- (UITableView*)transitionTableView;
@end


@protocol SSTansitionWaterfallGridViewProtocol <NSObject>

- (UIView*)snapShotForTransition;
@end

@protocol SSWaterFallViewControllerProtocol <SSTransitionProtocol>

- (void)viewWillAppearWithPageIndex:(NSInteger)pageIndex;
@end


@protocol SSHorizontalPageViewControllerProtocol <SSTransitionProtocol>

- (CGPoint)pageViewCellScrollViewContentOffset;
@end


#endif
