//
//  SSPersonalInfoViewController.m
//  GYM
//
//  Created by Sara on 15/5/19.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSPersonalInfoViewController.h"
#import "Macro.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "SSWaterfallViewCell.h"

@interface SSPersonalInfoViewController ()
{
    FrontScrollView *_frontScrollview;
    PersonalInfoView*_mainview;
}
@end



@implementation SSPersonalInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
          }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainview = [[PersonalInfoView alloc] initWithFrame:self.view.bounds];
    _frontScrollview = _mainview.frontScrollview;
   // _frontScrollview.contentSize = CGSizeMake(_frontScrollview.contentSize.width,  1500);
    [self.view addSubview:_mainview];
    
//    BackCollectionView *backView = [[BackCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[CHTCollectionViewWaterfallLayout alloc]init]];
//    [self.view addSubview:backView];
//    
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PersonalViewS" owner:nil options:nil] ;
//    _frontScrollview = views[0];
//    _frontScrollview.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//    _frontScrollview.delegate = self;
//    [self.view addSubview:_frontScrollview];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- frontScrollview delegate


@end
