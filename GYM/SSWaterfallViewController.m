//
//  SSWaterfallViewController.m
//  GYM
//
//  Created by Sara on 15/4/30.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSWaterfallViewController.h"
#import "SSWaterfallViewCell.h"
#import "Macro.h"
#import "SSNavigationController.h"
#import "WKCache.h"
#import "PicWallAPIManager.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"


@interface NavigationControllerDelegate:NSObject <UINavigationControllerDelegate>
@end
@implementation NavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    SSTransition* transition = [[SSTransition alloc]init];
    transition.presenting = (operation == UINavigationControllerOperationPop);
    return  transition;
}



@end


@interface SSWaterfallViewController () <APIManagerApiCallBackDelegate>
{
    NavigationControllerDelegate * _delegateHolder;
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
    
    //wk
    picWallViewModel *_viewModel;
}

@end

@implementation SSWaterfallViewController
static NSString *waterfallViewCellIdentify = @"waterfallViewCellIdentify";


//wk
- (instancetype)initWithViewModel:(picWallViewModel *)model WithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        _viewModel = model;
    }
    
    return self;
}


- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _smallImageURLList = [[NSMutableArray alloc] initWithCapacity:12];
    _bigImageURLList = [[NSMutableArray alloc] initWithCapacity:12];
//    _imageNameList = [[NSMutableArray alloc] init];
    _delegateHolder = [[NavigationControllerDelegate alloc] init];
    self.navigationController.delegate = _delegateHolder;
//    NSInteger idx = 0;
//    while (idx < 14) {
//        NSString* imageName = [[NSString alloc] initWithFormat:@"%ld.jpg",idx];
//        [_imageNameList addObject:imageName];
//        idx++;
//    }
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout*)self.collectionViewLayout;
    
    
    UICollectionView* collection  = self.collectionView;//frame : {{0, 0}, {375, 647}
    collection.frame = screenBounds;//CGRectMake(0, 44, screenWidth, screenHeight - 20 -44);
    collection.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"contentinset %@",NSStringFromUIEdgeInsets(layout.sectionInset));
    [collection registerClass:[SSWaterfallViewCell class] forCellWithReuseIdentifier:waterfallViewCellIdentify];
    [collection reloadData];
    self.hidesBottomBarWhenPushed = YES;
    
    //wk
    [[PicWallAPIManager sharedInstance] getNetworkDataWithParams:nil];
    [PicWallAPIManager sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    __weak __typeof(self)weakSelf = self;
    [_viewModel reformData:manager.fetchedData successBlock:^(NSDictionary *reformedData) {
        [weakSelf updateViewWithData:reformedData];
    }];
    NSLog(@"SSWaterfallViewController managerCallAPIDidSuccess");
   
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    
    NSLog(@"SSWaterfallViewController managerCallAPIDidFailed");
    
}

- (void)updateViewWithData:(NSDictionary *)data
{
    _smallImageURLList = data[@"smallPicURLArray"];
    _bigImageURLList = data[@"bigPicURLArray"];
    [self.collectionView reloadData];
}

#pragma mark -- UICollection datasource + delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _smallImageURLList.count ?_smallImageURLList.count : 12;
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
}

//wk
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForItemAtIndexPath:%li",indexPath.row);
    SSWaterfallViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterfallViewCellIdentify forIndexPath:indexPath];
    
    if (_smallImageURLList.count > 0 && _smallImageURLList[indexPath.row]){
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_smallImageURLList[indexPath.row]]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          if (image) {
                                                              
//                                                              UIImage *scaledImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(155.0, 211.36)];
                                                              [collectionCell addImageView:image];;
                                                              
                                                              [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_bigImageURLList[indexPath.row]]
                                                                                                              options:0
                                                                                                             progress:nil
                                                                                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                                                                if (image) {
                                                                                                                }
                                                                    }];
                                                          }
                                                      }];
    
    }
   
//    collectionCell.imageName = self.imageNameList[indexPath.row];
    //    [collectionCell setNeedsLayout];
    
//    [collectionCell addImageView:[self loadImageAtIndex:indexPath.item]];
//    if (indexPath.item < [self.imageNameList count] - 1) {
//        [self loadImageAtIndex:indexPath.item + 1];
//    }
//    if (indexPath.item > 0) {
//        [self loadImageAtIndex:indexPath.item - 1];
//    }
    
    return collectionCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    SSHorizontalPageViewController* pageViewController = [[SSHorizontalPageViewController alloc] initWithCollectionViewLayout:[self pageViewControllerLayout] currentIndexPath:indexPath];
    //    pageViewController.imageNameList = _imageNameList;
    SSphotoDetailTableViewVC *pageViewController = [[SSphotoDetailTableViewVC alloc] initWithStyle:UITableViewStylePlain currentIndexPath:indexPath];
    [collectionView setToIndexPath:indexPath];
    
//    pageViewController.imageName = _imageNameList[indexPath.row];
    pageViewController.imageName = _bigImageURLList[indexPath.row];

    [self.navigationController pushViewController:pageViewController animated: YES ];
}


#pragma mark -- CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //wk
//    UIImage *image = [UIImage imageNamed:_imageNameList[indexPath.row]];
//    CGFloat imageHeight = image.size.height * gridWidth/image.size.width;
    
//    UIImage *image = [[SDWebImageManager sharedManager] cachedImageForURLString:_smallImageURLList[indexPath.row]];
    UIImage *image = [UIImage imageNamed:@"6.jpg"];
    CGFloat imageHeight = image.size.height * gridWidth/image.size.width;
    return CGSizeMake(gridWidth, imageHeight + 50);//sara
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return  44;//sara 下移44  留给navigationbar
}



//wk
- (UIImage *)loadImageAtIndex:(NSUInteger)index
{
    //set up cache
    //if already cached, return immediately
    NSString *imageKey = [[NSString alloc] initWithFormat:@"%li",index];
//    NSLog(@"imageKey:%@",imageKey);
    //    NSString *imageKey = @"1";
    
    
    UIImage *image = [[WKCache sharedInstance] dataFromMemoryCacheForKey:imageKey];
    
    if (image) {
        return [image isKindOfClass:[NSNull class]]? nil: image;
        return image;
        
    }
    
    //set placeholder to avoid reloading image multiple times
    [[WKCache sharedInstance] storeData:[NSNull null] forKey:imageKey toDisk:NO];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageKey ofType:@"jpg"];
        NSString *imagePath = path;
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[WKCache sharedInstance] storeData:image forKey:imageKey toDisk:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{ //cache the image
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem: index inSection:0];
            SSWaterfallViewCell *cell = (SSWaterfallViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell addImageView:image];
        });
    });
    //not loaded yet
    return nil;
}


- (UICollectionViewFlowLayout*) pageViewControllerLayout {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //sara
    SSNavigationController*nav = (SSNavigationController*)self.navigationController;
    CGSize itemSize  = nav.navigationbar.hidden ? CGSizeMake(screenWidth, screenHeight) : CGSizeMake(screenWidth, screenHeight-navigationHeaderAndStatusbarHeight);
    flowLayout.itemSize = itemSize;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return flowLayout;
}


- (void)viewWillAppearWithPageIndex:(NSInteger)pageIndex {
    
    UICollectionViewScrollPosition position  = UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally;
//wk
//    UIImage* image = [UIImage imageNamed:self.imageNameList[pageIndex]];
    UIImage *image = [[SDWebImageManager sharedManager] cachedImageForURLString:_smallImageURLList[pageIndex]];

    CGFloat imageHeight = image.size.height*gridWidth/image.size.width;
    if (imageHeight > 1000) {//whatever you like, it's the max value for height of image
        position = UICollectionViewScrollPositionTop;
    }
    NSIndexPath* currentIndexPath =[NSIndexPath indexPathForRow:pageIndex inSection:0];
    UICollectionView* collectionView = self.collectionView;
    [collectionView setToIndexPath:currentIndexPath];
    if (pageIndex<2){
        [collectionView setContentOffset:CGPointZero animated:NO];
    }else{
        [collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition: position  animated: NO];
    }
}

- (UICollectionView*) transitionCollectionView{
    return self.collectionView;
}

#pragma mark --

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{
    NSLog(@"1");
    
    contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"scrollView.contentOffset:%f",contentOffsetY);
    
    //  oldContentOffsetY = scrollView.contentOffset.y;
    
}
// 滚动时调用此方法(手指离开屏幕后)

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//
//{
//    NSLog(@"2");
//
//}

// 完成拖拽(滚动停止时调用此方法，手指离开屏幕前)

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    NSLog(@"3");
    
    newContentOffsetY = scrollView.contentOffset.y;
    
    
    
    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
        
        
        
        //    NSLog(@"up");
        
        
        
    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
        
        
        
        //  NSLog(@"down");
        
    } else {
        
        
        
        //  NSLog(@"dragging");
        
    }
    
    
    
    if (scrollView.dragging) {  // 拖拽
        
        
        //
        //        NSLog(@"scrollView.dragging");
        //
        //
        //
        //        NSLog(@"contentOffsetY: %f", contentOffsetY);
        //
        //        NSLog(@"newContentOffsetY: %f", scrollView.contentOffset.y);
        
        
        
        if ((newContentOffsetY - contentOffsetY) > 5.0f) {  // 向上拖拽
            
            
            
            // 隐藏导航栏和选项栏
            
            self.navigationController.myNavigationbar.hidden = YES;
            
            self.tabBarController.tabBar.hidden = YES;
            
        } else if ((contentOffsetY - newContentOffsetY) > 5.0f) {   // 向下拖拽
            
            self.navigationController.myNavigationbar.hidden = NO;
            
            self.tabBarController.tabBar.hidden = NO;
            
            
            
        } else {
            
            
            
        }
        
    }
    
    oldContentOffsetY = scrollView.contentOffset.y;
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"4");
    self.navigationController.myNavigationbar.hidden = NO;
    oldContentOffsetY = scrollView.contentOffset.y;
    
}

@end
