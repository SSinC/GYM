//
//  WKPublicURLParamsGenerator.m
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "WKCommonParamsGenerator.h"
#import "WKAppContext.h"

@implementation WKCommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary
{
    WKAppContext *context = [WKAppContext sharedInstance];
    return @{
             @"cid":context.cid,
             @"ostype2":context.ostype2,
             @"udid2":context.udid2,
             @"uuid2":context.uuid2,
             @"app":context.appName,
             @"cv":context.cv,
             @"from":context.from,
             @"m":context.m,
             @"macid":context.macid,
             @"o":context.o,
             @"pm":context.pm,
             @"qtime":context.qtime,
             @"uuid":context.uuid,
             @"i":context.i,
             @"v":context.v
             };
}

+ (NSDictionary *)commonParamsDictionaryForLog
{
    WKAppContext *context = [WKAppContext sharedInstance];
    return @{
             @"guid":context.guid,
             @"dvid":context.dvid,
             @"net":context.net,
             @"ver":context.ver,
             @"ip":context.ip,
             @"mac":context.mac,
             @"geo":context.geo,
             @"uid":context.uid,
             @"chat_id":context.chatid,
             @"ccid":context.ccid,
             @"gcid":context.gcid,
             @"p":context.p,
             @"os":context.os,
             @"v":context.v,
             @"app":context.app,
             @"ch":context.channelID,
             @"ct":context.ct,
             @"pmodel":context.pmodel
             };
}

@end
