//
//  PersonInfoViw.m
//  GYM
//
//  Created by Sara on 15/5/22.
//  Copyright (c) 2015年 Sara. All rights reserved.
//


#import "BackCollectionView.h"


@interface HeaderForCollectionViewSection ()

@end
@implementation HeaderForCollectionViewSection
- (void)awakeFromNib
{
}


@end

@interface BackCollectionView()
{
    NSMutableArray * _imageNameList;
}
@end


@implementation BackCollectionView

static NSString *waterfallViewCellIdentify = @"waterfallViewCellIdentifyhh";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _imageNameList = [[NSMutableArray alloc] init];
        NSInteger idx = 0;
        while (idx < 14) {
            NSString* imageName = [[NSString alloc] initWithFormat:@"%ld.jpg",idx];
            [_imageNameList addObject:imageName];
            idx++;
        }
        self.dataSource = self;
        self.delegate = self;
        
        [self registerNib:[UINib nibWithNibName:@"HeaderForCollectionViewSection" bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [self registerClass:[SSWaterfallViewCell class] forCellWithReuseIdentifier:waterfallViewCellIdentify];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;

    }
    
    return self;
}

#pragma mark -- collection datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageNameList.count ;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    

    if (kind == CHTCollectionElementKindSectionHeader){
        HeaderForCollectionViewSection *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, headerView.height - 100, headerView.width, 100);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor clearColor].CGColor,
                           (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,nil];
        [headerView.layer addSublayer:gradient];

        reusableview = headerView;
        self.headerView = headerView;

    }
    
    return reusableview;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    SSWaterfallViewCell* collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterfallViewCellIdentify forIndexPath:indexPath];
    [collectionCell addImageView:[UIImage imageNamed:_imageNameList[indexPath.row]]];
//    collectionCell.imageName = _imageNameList[indexPath.row];
//    [collectionCell setNeedsLayout];
    return collectionCell;
}
#pragma mark -- CHTCollectionViewDelegateWaterfallLayout delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 300;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    return 3;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UIImage *image = [UIImage imageNamed:_imageNameList[indexPath.row]];
    CGFloat imageHeight = image.size.height*gridWidth/image.size.width;
    return CGSizeMake(gridWidth, imageHeight);//sara
}


@end
