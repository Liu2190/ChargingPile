//
//  NSString+Extension.m
//  chargingPile
//
//  Created by chargingPile on 15/5/26.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

+ (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSTimeInterval cha = now - late + 45;
    
    return [NSString stringWithFormat:@"%f",cha];
}

+ (double)getIntervalNow
{
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    return now;
}

- (NSString *)dateFormatOriginalString:(NSString *)origStr withString:(NSString *)intoStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:origStr];
    NSDate *origDate = [formatter dateFromString:self];
    [formatter setDateFormat:intoStr];
    NSString *str = [formatter stringFromDate:origDate];
    return str;
}

#pragma mark ----- md5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)cmpContainsWithString:(NSString *)str
{
    if (iOS8) {
       return [self containsString:str];
    }
    
    NSRange range = [self rangeOfString:str];
    if (range.length != 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
