//
//  picWallViewModel.m
//  GYM
//
//  Created by wktzjz on 15/6/1.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "picWallViewModel.h"

@implementation picWallViewModel

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _modelID = @"viewModelPicWall";
        _wallSmallPicUrlArray = [[NSMutableArray alloc] initWithCapacity:12];
        _wallBigPicUrlArray = [[NSMutableArray alloc] initWithCapacity:12];

    }
    
    return self;
}

/****************************************
{
    "success":true,
    "errorCode":0,
    "msg":"操作成功",
    "errors":null,
    "data":{
        "limit":20,
        "total":12,
        "page":1,
        "totalPages":1,
        "rows":[
                {
                    "id":1,
                    "custId":0,
                    "custName":"光着脚",
                    "custImg":"http://img5.duitang.com/uploads/item/201408/25/20140825111147_iefmN.thumb.224_0.jpeg",
                    "imgUrl":"http://img1.juimg.com/140922/330698-14092222430638.jpg",
                    "smallImgUrl":"http://img1.juimg.com/140922/330698-14092222430638.jpg",
                    "zanCount":305,
                    "createTime":1433328949000
                },
                {
                    "id":2,
                    "custId":0,
                    "custName":"光着脚",
                    "custImg":"http://img5.duitang.com/uploads/item/201408/25/20140825111147_iefmN.thumb.224_0.jpeg",
                    "imgUrl":"http://pic8.nipic.com/20100618/2846024_080717082088_2.jpg",
                    "smallImgUrl":"http://pic8.nipic.com/20100618/2846024_080717082088_2.jpg",
                    "zanCount":403,
                    "createTime":1433156161000
                },
                ]
    }
}
**************************************/

- (void)reformData:(NSDictionary *)data successBlock:(reformDataCallBack)success
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        @autoreleasepool {
            
            NSArray *dataArray = ((NSDictionary *)data[@"data"])[@"rows"];
            [dataArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
                [_wallSmallPicUrlArray addObject:dic[@"smallImgUrl"]];
                [_wallBigPicUrlArray addObject:dic[@"imgUrl"]];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(
                          @{@"smallPicURLArray":_wallSmallPicUrlArray,
                            @"bigPicURLArray":_wallBigPicUrlArray,
                           }
                        );
            });
            
        }
    });
}


@end
