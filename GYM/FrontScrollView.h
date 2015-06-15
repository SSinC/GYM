//
//  FrontScrollView.h
//  GYM
//
//  Created by Sara on 15/5/22.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@protocol SSTagLayoutDelegate

@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SSTagLayout : UICollectionViewLayout
@property(nonatomic)NSInteger sections;
@property(nonatomic)CGFloat columSpacing;
@property(nonatomic)CGFloat rowSpacing;
@property(nonatomic)NSInteger rowCount;
@property(nonatomic)UIEdgeInsets sectionInset;

@end



@interface SSTagCollectionview : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate,SSTagLayoutDelegate>
@property(nonatomic)NSMutableArray *dataList;

@end

@interface FrontMainView : UIView
@property (weak, nonatomic) IBOutlet SSTagCollectionview *tagCollectionView;

@end

@interface FrontScrollView : UIScrollView
@end
