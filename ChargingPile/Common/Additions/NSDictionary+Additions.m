//
//  NSDictionary+Additions.m
//  chargingPile
//
//  Created by chargingPile on 15/1/27.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "NSString+Extension.h"

@implementation NSDictionary (Additions)

- (BOOL)boolValueForKey:(NSString *)key
{
    return [self boolValueForKey:key defaultValue:NO];
}
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    if(![self isNullWithKey:key])
    {
        return [[self objectForKey:key] boolValue];
    }
    return defaultValue;
}

- (int)intValueForKey:(NSString *)key
{
    return [self intValueForKey:key defaultValue:0];
}
- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
    if(![self isNullWithKey:key])
    {
        return [[self objectForKey:key] intValue];
    }
    return defaultValue;
}

- (float)floatValueForKey:(NSString *)key
{
    return [self floatValueForKey:key defaultValue:0];
}
- (float)floatValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
    if(![self isNullWithKey:key])
    {
        return [[self objectForKey:key] floatValue];
    }
    return defaultValue;
}

- (NSString *)stringValueForKey:(NSString *)key
{
    return [self stringValueForKey:key defaultValue:@""];
}
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    if([self isNullWithKey:key])
    {
        return defaultValue;
    }
    if([[self objectForKey:key] isKindOfClass:[NSString class]])
    {
        return [self objectForKey:key];
    }
    if([[self objectForKey:key]isKindOfClass:[NSNumber class]])
    {
        return [[self objectForKey:key]stringValue];
    }
    return defaultValue;
}

- (NSArray *)arrayValueForKey:(NSString *)key
{
    if(![self isNullWithKey:key])
    {
        if([[self objectForKey:key]isKindOfClass:[NSArray class]])
        {
            return [self objectForKey:key];
        }
    }
    return nil;
}

- (NSDictionary *)dictValueForKey:(NSString *)key
{
    if(![self isNullWithKey:key])
    {
        if([[self objectForKey:key]isKindOfClass:[NSDictionary class]])
        {
            return [self objectForKey:key];
        }
    }
    return nil;
}
#pragma mark - privateMethod

- (BOOL)isNullWithKey:(NSString *)key
{
    if ([[self objectForKey:key] isKindOfClass:[NSNull class]]||[self objectForKey:key]==nil) {
        return YES;
    }
    if ([[self objectForKey:key] isKindOfClass:[NSString class]]) {
        NSString *value = [[self objectForKey:key] lowercaseString];
        if ([value rangeOfString:@"null"].location!=NSNotFound)
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)speCallCarRequestParam
{
    NSArray *keyArray = [self allKeys];
    NSArray *sortedArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    NSString *paramStr = @"";
    for (NSString *keyStr in sortedArray) {
        if (paramStr.length == 0) {
            paramStr = [NSString stringWithFormat:@"%@=%@", keyStr, [self objectForKey:keyStr]];
        } else {
            paramStr = [NSString stringWithFormat:@"%@&%@=%@", paramStr, keyStr, [self objectForKey:keyStr]];
        }
    }
    paramStr = [NSString md5:paramStr];
    return paramStr;
}



@end
