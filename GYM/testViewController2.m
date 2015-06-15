//
//  testViewController2.m
//  GYM
//
//  Created by wktzjz on 15/5/28.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "testViewController2.h"
#import "PicWallAPIManager.h"

@interface testViewController2 ()

@end

@implementation testViewController2
{
    UIImageView *_imageView;
    picWallViewModel *_viewModel;
    PicWallAPIManager *_picWallAPIManager;
    
    id testData;
}

- (instancetype)initWithViewModel:(picWallViewModel *)model
{
    self = [super init];
    if (self) {
        _viewModel = model;
        _picWallAPIManager = [PicWallAPIManager sharedInstance];
        [_picWallAPIManager getNetworkDataWithParams:nil];
        _picWallAPIManager.delegate = self;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"6.jpg"];
    _imageView = [[UIImageView alloc]initWithImage:image];
    _imageView.frame = CGRectMake(100, 100, 132, 180);
    [self.view addSubview:_imageView];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
//    [self startNotification];
    testData = manager.fetchedData;
    [_animator completePresent];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"managerCallAPIDidFailed");
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    //    __weak __typeof(self) weakself = self;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [_animator completePresent];

    });
    
}

- (void)handleTap:(UITapGestureRecognizer *)recongnizer
{
    CGPoint locationInMainView = [recongnizer locationInView:self.view];
    
    if (CGRectContainsPoint(_imageView.frame, locationInMainView)) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
