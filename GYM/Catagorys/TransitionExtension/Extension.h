//
//  Extension.h
//  GYM
//
//  Created by Sara on 15/5/12.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (Utils)

- (void)origin:(CGPoint)point;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)bottom;

@end



@interface UIView (Transition)

- (void)setToIndexPath:(NSIndexPath*)indexpath;
- (NSIndexPath*)toIndexPath;
- (NSIndexPath*)fromPageIndexPath;

@end


@interface UINavigationController (Navigationbar)
//- (BOOL)myNavigationbarHidden;
//- (void)setMyNavigationbarHidden:(BOOL)hide;
- (UIView*)myNavigationbar;
- (void)setMyNavigationbar:(UIView*)navigationbar;

@end
//
//@interface UINavigationBar (BackgroundColor)
//- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
//
//@end