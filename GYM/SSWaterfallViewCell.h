//
//  SSWaterfallViewCell
//  GYM
//
//  Created by Sara on 15/5/12.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTransitionProtocol.h"
@interface SSWaterfallViewCell : UICollectionViewCell <SSTansitionWaterfallGridViewProtocol>
@property(nonatomic,copy) NSString* imageName ;

@property (nonatomic, strong) UIImageView *imageViewContent;

- (void)addImageView:(UIImage *)image;

@end
