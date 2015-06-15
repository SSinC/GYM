//
//  testViewController1.m
//  GYM
//
//  Created by wktzjz on 15/5/28.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "testViewController1.h"
#import "testViewController2.h"
#import "WKTransition.h"
#import "UIViewController+clickedViewIndex.h"
#import "appViewModel.h"
#import "ViewModelKeys.h"

@interface testViewController1 ()
//<UIViewControllerTransitioningDelegate>

@end

@implementation testViewController1
{
    UIImageView *_imageView;
    WKTransition *_animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"6.jpg"];
    _imageView = [[UIImageView alloc]initWithImage:image];
    _imageView.frame = CGRectMake(200, 300, 132, 180);//132,180
    [self.view addSubview:_imageView];
    
    self.view.backgroundColor = [UIColor yellowColor];
     _animator = [WKTransition new];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)handleTap:(UITapGestureRecognizer *)recongnizer
{
        CGPoint locationInMainView = [recongnizer locationInView:self.view];
        
        if (CGRectContainsPoint(_imageView.frame, locationInMainView)) {
            
            [self setClickedView:_imageView];
//            NSLog(@"clickedView :%@",[self clickedView]);
            CGRect frame = _imageView.frame;
            [self setClickedViewFrame:@[@(frame.origin.x),@(frame.origin.y),@(frame.size.width),@(frame.size.height)]];

            picWallViewModel *viewModel = (picWallViewModel *)[[appViewModel sharedInstance] viewModelWithIdentifier:viewModelTestKey];
            testViewController2 *vc = [[testViewController2 alloc] initWithViewModel:viewModel];
            
            WKTransition *animator = [WKTransition new];
            vc.animator = animator;
            [animator startObervesr];
            [animator wireToViewController:vc];
            vc.transitioningDelegate = animator;
            vc.modalPresentationCapturesStatusBarAppearance = YES;
            vc.modalPresentationStyle = UIModalPresentationCustom;

            __weak __typeof(self) weakSelf = self;
            animator.startDismissModalViewControllerBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:vc animated:YES completion:nil];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting
//                                                                      sourceController:(UIViewController *)source
//{
//    return [PresentingAnimator new];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return _dismissTransitionController;
//}
//
//-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    return _dismissTransitionController.interacting ? _dismissTransitionController : nil;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
