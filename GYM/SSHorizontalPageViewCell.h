//
//  SSHorizontalPageViewCell.h
//  GYM
//
//  Created by Sara on 15/5/12.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface  SSTableViewCell : UITableViewCell

@end

@interface SSHorizontalPageViewCell : UICollectionViewCell <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)   NSString* imageName;
@property(nonatomic,copy)   void (^tappedAction)();
@property(nonatomic,copy)   void (^pullAction)(CGPoint offset);

@end
