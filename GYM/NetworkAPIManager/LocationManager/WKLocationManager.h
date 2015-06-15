//
//  WKLocationManager.h
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "APIBaseManager.h"
#import "WKCityListManager.h"
#import <CoreLocation/CoreLocation.h>

extern NSString * const WKLocationManagerDidSuccessedLocateNotification;
extern NSString * const WKLocationManagerDidFailedLocateNotification;
extern NSString * const WKLocationManagerDidSwitchCityNotification;

typedef NS_ENUM(NSUInteger, WKLocationManagerLocationResult) {
    WKLocationManagerLocationResultDefault,              //默认状态
    WKLocationManagerLocationResultLocating,             //定位中
    WKLocationManagerLocationResultSuccess,              //定位成功
    WKLocationManagerLocationResultFail,                 //定位失败
    WKLocationManagerLocationResultParamsError,          //调用API的参数错了
    WKLocationManagerLocationResultTimeout,              //超时
    WKLocationManagerLocationResultNoNetwork,            //没有网络
    WKLocationManagerLocationResultNoContent             //API没返回数据或返回数据是错的
};

typedef NS_ENUM(NSUInteger, WKLocationManagerLocationServiceStatus) {
    WKLocationManagerLocationServiceStatusDefault,               //默认状态
    WKLocationManagerLocationServiceStatusOK,                    //定位功能正常
    WKLocationManagerLocationServiceStatusUnknownError,          //未知错误
    WKLocationManagerLocationServiceStatusUnAvailable,           //定位功能关掉了
    WKLocationManagerLocationServiceStatusNoAuthorization,       //定位功能打开，但是用户不允许使用定位
    WKLocationManagerLocationServiceStatusNoNetwork,             //没有网络
    WKLocationManagerLocationServiceStatusNotDetermined          //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};


@interface WKLocationManager : APIBaseManager <APIManagerApiCallBackDelegate, CLLocationManagerDelegate>

@property (nonatomic, copy, readonly) NSString *selectedCityId;
@property (nonatomic, copy, readonly) NSString *selectedCityName;
@property (nonatomic, copy, readonly) CLLocation *selectedCityLocation;

@property (nonatomic, copy, readonly) NSString *locatedCityId;
@property (nonatomic, copy, readonly) NSString *locatedCityName;
@property (nonatomic, copy, readonly) CLLocation *locatedCityLocation;

@property (nonatomic, copy, readonly) NSString *currentCityId;
@property (nonatomic, copy, readonly) NSString *currentCityName;
@property (nonatomic, copy, readonly) CLLocation *currentCityLocation;

@property (nonatomic, readonly) BOOL isUsingLocatedData;

@property (nonatomic, readonly) WKLocationManagerLocationResult locationResult;
@property (nonatomic, readonly) WKLocationManagerLocationServiceStatus locationStatus;

@property (nonatomic, strong) WKCityListManager *cityListManager;

+ (instancetype)sharedInstance;

- (BOOL)isInLocatedCity;
- (BOOL)isInLocatedCityWithLocation:(CLLocation *)location;

- (BOOL)checkLocationAndShowingAlert:(BOOL)showingAlert;

- (void)startLocation;
- (void)stopLocation;
- (void)restartLocation;

- (void)switchToCityWithCityId:(NSString *)cityId;
- (void)loadCurrentCityDataFromPlist;

@end
