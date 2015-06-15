//
//  BackCollectionView.h
//  GYM
//
//  Created by Sara on 15/5/22.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "Extension.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "SSWaterfallViewCell.h"
@interface HeaderForCollectionViewSection :UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@interface BackCollectionView :UICollectionView <  UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property(nonatomic)HeaderForCollectionViewSection *headerView;

@end