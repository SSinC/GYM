//
//  WKDefine.h
//  snDataAnalytics
//
//  Created by wktzjz on 15-4-8.
//  Copyright (c) 2015年 wktzjz. All rights reserved.
//

#ifndef snDataAnalytics_WKDefine_h
#define snDataAnalytics_WKDefine_h

typedef void(^WKNoParamsBlock)();

#if OS_OBJECT_USE_OBJC
#undef WKDispatchQueueRelease
#undef WKDispatchQueueSetterSementics
#define WKDispatchQueueRelease(q)
#define WKDispatchQueueSetterSementics strong
#else
#undef WKDispatchQueueRelease
#undef WKDispatchQueueSetterSementics
#define WKDispatchQueueRelease(q) (dispatch_release(q))
#define WKDispatchQueueSetterSementics assign
#endif

#endif
