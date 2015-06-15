//
//  SSWaterfallViewCellCollectionViewCell.m
//  GYM
//
//  Created by Sara on 15/5/12.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSWaterfallViewCell.h"
@interface  SSWaterfallViewCell()
{
//    UIImageView* _imageViewContent;
    
}
@end

@implementation SSWaterfallViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
   // fatalError("init(coder:) has not been implemented");
    [NSException raise:NSStringFromClass([self class]) format:@"init(coder:) has not been implemented."];

    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _imageViewContent = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageViewContent];
        
        self.layer.cornerRadius = 5.0;

    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
////    _imageViewContent.image = [UIImage imageNamed:_imageName];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //load image
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"];
//        NSLog(@"path:%@",path);
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//
//        //redraw image using device context
////        UIGraphicsBeginImageContextWithOptions(_imageViewContent.bounds.size, YES, 0);
////        [image drawInRect:_imageViewContent.bounds];
////         NSLog(@"%@",NSStringFromCGRect(_imageViewContent.bounds));
////        image = UIGraphicsGetImageFromCurrentImageContext();
////        UIGraphicsEndImageContext();
//        //set image on main thread, but only if index still matches up
//
//        CGFloat xoffset = 0 ;
//        CGFloat yoffset = 0 ;
//        _imageViewContent.frame = CGRectMake(xoffset,yoffset , self.frame.size.width - 2*xoffset, (self.frame.size.width - 2*xoffset) * image.size.height/image.size.width );//sara
//
//        UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
//        [image drawAtPoint:CGPointZero];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
////        NSLog(@"%@",NSStringFromCGRect(_imageViewContent.bounds));
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//                 _imageViewContent.image = image;
//
////            CGFloat xoffset = 0 ;
////            CGFloat yoffset = 0 ;
////            _imageViewContent.frame = CGRectMake(xoffset,yoffset , self.frame.size.width - 2*xoffset, (self.frame.size.width - 2*xoffset) * _imageViewContent.image.size.height/_imageViewContent.image.size.width );//sara
////
////            NSLog(@"%@",NSStringFromCGRect(_imageViewContent.frame));
//
//        });
//    });
//
//}

- (void)addImageView:(UIImage *)image
{
    if (image == nil) {
        return;
    }
    
    CGFloat xoffset = 0 ;
    CGFloat yoffset = 0 ;
    _imageViewContent.frame = CGRectMake(xoffset,yoffset , self.frame.size.width - 2*xoffset, (self.frame.size.width - 2*xoffset) * image.size.height/image.size.width );//sara
    NSLog(@"frame:%@",NSStringFromCGRect(_imageViewContent.frame));
    
    _imageViewContent.image = image;
    
    
}


- (UIView*)snapShotForTransition
{
    UIImageView* snapShotView = [[UIImageView alloc] initWithImage:_imageViewContent.image];
    snapShotView.frame = _imageViewContent.frame;
    return snapShotView;
}


@end
