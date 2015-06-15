//
//  PersonalInfoView.h
//  GYM
//
//  Created by Sara on 15/5/22.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontScrollView.h"

@interface PersonalInfoView :  UIView<UIScrollViewDelegate>
@property(nonatomic)   FrontScrollView  *frontScrollview;

- (void)hideBottomView:(BOOL)hide animatied:(BOOL)animatid;
@end
