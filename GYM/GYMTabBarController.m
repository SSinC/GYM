//
//  GYMTabBarController.m
//  GYM
//
//  Created by Sara on 15/4/30.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "GYMTabBarController.h"
#import "SSWaterfallViewController.h"
#import "SSPersonalInfoViewController.h"
#import "SSNavigationController.h"
#import "testViewController1.h"

#import "appViewModel.h"
#import "ViewModelKeys.h"


@interface GYMTabBarController ()

@end

@implementation GYMTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.tabBar.tintColor = [UIColor yellowColor];//item 文字选中的颜色
//    self.tabBar.barStyle = UIBarStyleBlack;
   // self.tabBar.hidden = YES;
    
    _tabbar = [[SSTabbarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    //[self.view addSubview:_tabbar];
    
    picWallViewModel *viewModel = (picWallViewModel *)[[appViewModel sharedInstance] viewModelWithIdentifier:viewModelTestKey];
    SSWaterfallViewController *vc1 = [[SSWaterfallViewController alloc] initWithViewModel:viewModel WithCollectionViewLayout:[[CHTCollectionViewWaterfallLayout alloc]init]];
    vc1.title = @"首页";
    SSNavigationController*nav1 = [[SSNavigationController alloc] initWithRootViewController:vc1];
    
    SSPersonalInfoViewController *Vc2 = [[SSPersonalInfoViewController alloc] init];
    Vc2.title = @"账户";
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:Vc2];
    [nav2 setNavigationBarHidden:YES ];
    
    testViewController1 *vc3 = [[testViewController1 alloc] init];
    vc3.title = @"测试";
    [nav2 setNavigationBarHidden:YES ];
    
    self.viewControllers = @[nav1,nav2,vc3];
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
