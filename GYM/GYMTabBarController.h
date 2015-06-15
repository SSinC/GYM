//
//  GYMTabBarController.h
//  GYM
//
//  Created by Sara on 15/4/30.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTabbarView.h"

@interface GYMTabBarController : UITabBarController<UITabBarControllerDelegate>
@property(nonatomic)    SSTabbarView *tabbar;
@end
