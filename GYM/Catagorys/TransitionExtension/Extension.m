//
//  Extension.m
//  GYM
//
//  Created by Sara on 15/5/12.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "Extension.h"
#import <objc/runtime.h>

@implementation UIView (Utils)

- (void)origin:(CGPoint)point
{
    CGRect rc = self.frame;
    rc.origin.x = point.x;
    rc.origin.y = point.y;
    self.frame = rc;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

@end

NSString* kIndexPathPointer = @"kIndexPathPointer";

@implementation UIView (Transition)

- (void)setToIndexPath:(NSIndexPath*)indexpath
{
    objc_setAssociatedObject(self, &kIndexPathPointer, indexpath,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSIndexPath*)toIndexPath
{
    return objc_getAssociatedObject(self,&kIndexPathPointer);
    //    NSInteger index = self.contentOffset.x/self.frame.size.width;
    //    NSIndexPath *indexpath = objc_getAssociatedObject(self,&kIndexPathPointer);
    //    if (index > 0)
    //    {
    //        return [NSIndexPath indexPathForRow:index inSection:0];
    //    }else if (indexpath && [indexpath isKindOfClass:[NSIndexPath class]]) {
    //        return indexpath;
    //    }else{
    //        return [NSIndexPath indexPathForRow:0 inSection:0];
    //    }
}

//- (NSIndexPath*)fromPageIndexPath
//{
//    int index = (int)self.contentOffset.x/self.frame.size.width;
//    return [NSIndexPath indexPathForRow:index inSection:0];
//
//}

@end

//static char koverlayKey;
//@implementation UINavigationBar (BackgroundColor)
//
//- (UIView *)overlay
//{    return objc_getAssociatedObject(self, &koverlayKey);
//}
//
//- (void)setOverlay:(UIView *)overlay
//{
//    objc_setAssociatedObject(self, &koverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
//{
//    if (!self.overlay) {
//
//        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self setShadowImage:[UIImage new]];        // insert an overlay into the view hierarchy
//        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
//        [self insertSubview:self.overlay atIndex:0];
//    }
//    self.overlay.backgroundColor = backgroundColor;
//}
//
//@end
static char    SSNavigationBarHideKey ;
static char    SSNavigationBarKey ;

@implementation UINavigationController (Navigationbar)

//- (BOOL)myNavigationbarHidden
//{
//    return [(NSNumber*)objc_getAssociatedObject(self, &SSNavigationBarHideKey) boolValue];
//}
//- (void)setMyNavigationbarHidden:(BOOL)hide
//{
//    if (self.myNavigationbarHidden == hide)
//        return;
//
//    objc_setAssociatedObject(self, &SSNavigationBarHideKey, [NSNumber numberWithBool:hide], OBJC_ASSOCIATION_ASSIGN);
//    self.myNavigationbar.hidden = hide;
//}

- (UIView*)myNavigationbar
{
    return objc_getAssociatedObject(self, &SSNavigationBarKey);
}

- (void)setMyNavigationbar:(UIView*)navigationbar
{
    objc_setAssociatedObject(self, &SSNavigationBarKey,navigationbar, OBJC_ASSOCIATION_ASSIGN);
    
}
@end