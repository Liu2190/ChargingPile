//
//  JrString.m
//  qiuyingios
//
//  Created by musmile on 14-2-15.
//  Copyright (c) 2014年 zdqk. All rights reserved.
//

#import "JrStringUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation JrStringUtil

/**
 *规则为从左到右一段一段判断versionA是否比versionB更大，如果遇到0.8.19.1与0.8.19这样的情况，段数多者更大，
 *如果是0.8.19 与0.8.19.0则不会返回更大
 *例:versionA   versionB   return
 * 0.1          0.2         NO
 */
+ (BOOL)isVersionBigger:(NSString*)versionA biggerThanVersion:(NSString*)versionB
{
    NSArray *arrayNow = [versionB componentsSeparatedByString:@"."];
    NSArray *arrayNew = [versionA componentsSeparatedByString:@"."];
    BOOL isBigger = NO;
    NSInteger i = arrayNew.count > arrayNow.count? arrayNow.count : arrayNew.count;
    NSInteger j = 0;
    BOOL hasResult = NO;
    for (j = 0; j < i; j ++) {
        NSString* strNew = [arrayNew objectAtIndex:j];
        NSString* strNow = [arrayNow objectAtIndex:j];
        if ([strNew integerValue] > [strNow integerValue]) {
            hasResult = YES;
            isBigger = YES;
            break;
        }
        if ([strNew integerValue] < [strNow integerValue]) {
            hasResult = YES;
            isBigger = NO;
            break;
        }
    }
    if (!hasResult) {
        if (arrayNew.count > arrayNow.count) {
            NSInteger nTmp = 0;
            NSInteger k = 0;
            for (k = arrayNow.count; k < arrayNew.count; k++) { 
                nTmp += [[arrayNew objectAtIndex:k]integerValue]; 
            } 
            if (nTmp > 0) { 
                isBigger = YES; 
            } 
        } 
    } 
    return isBigger; 
}

+ (NSString *)getDate:(NSString *)aTime
{
	NSRange range;
	range.location = 8;
	range.length = 2;
	NSString *day = [aTime substringWithRange:range];
	return day;

}

+ (NSString *)getMonth:(NSString *)aTime
{
	NSRange range;
	range.location = 5;
	range.length = 2;
	NSString *month = [aTime substringWithRange:range];
	return month;
}

+ (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (uint)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    return mdfiveString;
}

@end
