//
//  picWallViewModel.h
//  GYM
//
//  Created by wktzjz on 15/6/1.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseViewModel.h"

@interface picWallViewModel : baseViewModel <baseViewModelProtocal>

@property (nonatomic, readonly) NSString *modelID;

@property (nonatomic, strong) NSMutableArray *wallSmallPicUrlArray;
@property (nonatomic, strong) NSMutableArray *wallBigPicUrlArray;


@end
