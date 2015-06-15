//
//  SSphotoDetailTableViewVC.h
//  GYM
//
//  Created by Sara on 15/5/29.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "Extension.h"
#import "SSTransitionProtocol.h"
@interface  SSCommentTableViewCell : UITableViewCell

@end
@interface SSphotoDetailTableViewVC : UITableViewController<SSTransitionProtocol,SSHorizontalPageViewControllerProtocol>

@property(nonatomic,copy)   NSString* imageName;
@property(nonatomic,copy)   void (^tappedAction)();
@property(nonatomic,copy)   void (^pullAction)(CGPoint offset);
- (instancetype)initWithStyle:(UITableViewStyle)style currentIndexPath:(NSIndexPath*)indexpath;

@end
