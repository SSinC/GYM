//
//  baseViewModel.h
//  GYM
//
//  Created by wktzjz on 15/6/3.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^reformDataCallBack)(id reformedData);


// 所有baseViewModelProtocal的派生类都要符合这个protocal
@protocol baseViewModelProtocal <NSObject>

@property (nonatomic, readonly) NSString *modelID;

@end


@interface baseViewModel : NSObject

- (void)reformData:(id)data successBlock:(reformDataCallBack)success;

@end
