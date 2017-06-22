//
//  JrString.h
//  qiuyingios
//
//  Created by musmile on 14-2-15.
//  Copyright (c) 2014年 zdqk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JrStringUtil: NSObject

/**
 *规则为从左到右一段一段判断versionA是否比versionB更大，如果遇到0.8.19.1与0.8.19这样的情况，段数多者更大，
 *如果是0.8.19 与0.8.19.0则不会返回更大
 *例:versionA   versionB   return
 * 0.1          0.2         NO
 */
+ (BOOL)isVersionBigger:(NSString*)versionA biggerThanVersion:(NSString*)versionB;
+ (NSString *)getDate:(NSString *)aTime;
+ (NSString *)getMonth:(NSString *)aTime;
+ (NSString *)md5HexDigest:(NSString*)password;
@end
