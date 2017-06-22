//
//  NSString+Additions.m
//  SideBenefit
//
//  Created by chargingPile on 15/3/12.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)
- (NSString *)getPinyinCharacter
{
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *returnString = [source stringByReplacingOccurrencesOfString:@" "withString:@""];
    [returnString lowercaseString];
    return returnString;
}
@end
