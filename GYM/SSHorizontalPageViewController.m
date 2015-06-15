//
//  SSHorizontalPageViewController.m
//  GYM
//
//  Created by Sara on 15/5/14.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSHorizontalPageViewController.h"
#import "SSHorizontalPageViewCell.h"
#import "Extension.h"
@interface SSHorizontalPageViewController ()
@property(nonatomic)    CGPoint pullOffset;

@end

@implementation SSHorizontalPageViewController

static NSString * const horizontalPageViewCellIdentify = @"horizontalPageViewCellIdentify";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout currentIndexPath:(NSIndexPath*)indexpath

{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _pullOffset = CGPointZero;
        UICollectionView* collectionView  = self.collectionView;
        collectionView.pagingEnabled = true;
        [collectionView registerClass:[SSHorizontalPageViewCell class] forCellWithReuseIdentifier: horizontalPageViewCellIdentify];
       // collectionView.frame = CGRectMake(0, 14, screenWidth, screenHeight);//sara
        [collectionView setToIndexPath:indexpath];
        [collectionView performBatchUpdates:^{
            [collectionView reloadData];
        } completion:^(BOOL finished) {
            if (finished) {
                [collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageNameList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SSHorizontalPageViewCell* collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:horizontalPageViewCellIdentify  forIndexPath: indexPath];
    collectionCell.imageName = self.imageNameList[indexPath.row] ;
    collectionCell.tappedAction = ^{};
    collectionCell.pullAction = ^(CGPoint offset){
        self.pullOffset = offset;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [collectionCell setNeedsLayout];
    return collectionCell;
    
}

#pragma mark --
- (UICollectionView*)transitionCollectionView
{
    return self.collectionView;
}

- (CGPoint)pageViewCellScrollViewContentOffset
{
    return self.pullOffset;
}


@end
