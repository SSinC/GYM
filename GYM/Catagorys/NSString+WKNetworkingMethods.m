//
//  NSString+WKNetworkingMethods.m
//  WKNetworking
//
//  Created by wktzjz.
//  Copyright (c) wktzjz@gmail.com. All rights reserved.
//

#import "NSString+WKNetworkingMethods.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (WKNetworkingMethods)

- (NSString *)WK_md5
{
	NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
	
	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];
	
	return hashStr;
}

@end
