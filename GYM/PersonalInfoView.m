//
//  PersonalInfoView.m
//  GYM
//
//  Created by Sara on 15/5/22.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "PersonalInfoView.h"
#import "BackCollectionView.h"


typedef enum {
    dragDefault = 0,
    dragUp,
    dragdown
} dragDirection;

@interface PersonalInfoView() <UIGestureRecognizerDelegate>
{
    BackCollectionView  *_backCollectionView;
    UIView              *_bottomView;
}
@end


@implementation PersonalInfoView
{
    CGFloat _initalBackgroundCenterY;
    CGFloat _backgroundViewDistanceY;
    NSInteger _dragDirection;
    CGFloat _lastFrontoffsetY;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
 //      self.contentSize = CGSizeMake(frame.size.width, 1500);//tmp
//        self.delegate = self;
    //    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
   //     self.contentOffset = CGPointMake(0, 0);
        _backCollectionView = [[BackCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[CHTCollectionViewWaterfallLayout alloc]init]];
        [self addSubview:_backCollectionView];
        
        _frontScrollview = [[FrontScrollView alloc] initWithFrame:self.bounds];
//        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PersonalViewS" owner:nil options:nil] ;
//        _frontScrollview = views[0];
//        _frontScrollview.frame = self.bounds;
        _frontScrollview.delegate = self;
        [self addSubview:_frontScrollview];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 85, self.width, 40)];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _bottomView.hidden = YES;
        [self addSubview:_bottomView];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
        [_bottomView addGestureRecognizer:ges];
        
        _initalBackgroundCenterY = _backCollectionView.center.y;
          }
    
    return self;
}



- (void)handleGes:(UIGestureRecognizer*)ges
{
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _frontScrollview.center = self.center;
                         _backCollectionView.contentOffset = CGPointMake(_backCollectionView.contentOffset.x, -20);//todo
                     } completion:^(BOOL finished) {
                         
                         [self hideBottomView:YES animatied:NO];

                     }];

}


- (void)hideBottomView:(BOOL)hide animatied:(BOOL)animatid
{
    _bottomView.hidden = hide;
    if (animatid)
    {
        
    }
}


- (void)handleDragUpWithTranslationY:(CGFloat)translationY
{
    
    if (_backgroundViewDistanceY <= 0.000001 && _frontScrollview.contentOffset.y > 0){
        
        CGFloat centery = _backCollectionView.center.y;
        _backCollectionView.center = CGPointMake(_backCollectionView.center.x ,centery + translationY);
        _backgroundViewDistanceY += translationY;
    }
}

- (void)handleDragDownWithTranslationY:(CGFloat)translationY
{
    
    
    if (_backgroundViewDistanceY < 0.000001){
        
        if ((_backgroundViewDistanceY + translationY) > 0.000001 ) {
            _backCollectionView.center =CGPointMake(_backCollectionView.center.x ,_initalBackgroundCenterY);
            _backgroundViewDistanceY = 0;

        }
        else
        {
            CGFloat centery = _backCollectionView.center.y;
            _backCollectionView.center = CGPointMake(_backCollectionView.center.x ,centery + translationY);
            _backgroundViewDistanceY += translationY;

        }

    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastFrontoffsetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat transiY = _lastFrontoffsetY - scrollView.contentOffset.y;
    
    _lastFrontoffsetY = scrollView.contentOffset.y;
    
    if ( transiY == 0) {
        _dragDirection = dragDefault;
    }
    else if (transiY > 0)
        _dragDirection = dragdown;
    else
        _dragDirection = dragUp;
    
    switch (_dragDirection) {
        case dragdown:
        {
            [self handleDragDownWithTranslationY:transiY];
            break;
        }
        case dragUp:
        {
            [self handleDragUpWithTranslationY:transiY];
            break;
        }
        default:
            break;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y <= -60.0) {
        
        CGPoint center = _frontScrollview.center;
        CGPoint origin = [_frontScrollview convertPoint:_frontScrollview.frame.origin toView:self];
        [UIView animateWithDuration:1.0 animations:^{
            _frontScrollview.center = CGPointMake(center.x, center.y + (self.frame.size.height - origin.y));
            
        } completion:^(BOOL finished) {
            
            [self hideBottomView:NO animatied:NO];
            
        }];
    }
}

@end
