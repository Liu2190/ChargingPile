//
//  ColorUtility.m
//  chargingPile
//
//  Created by chargingPile on 15/1/27.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "ColorUtility.h"

@implementation ColorUtility
static const float kColorRangeTopValue = 255.0f;
+ (UIColor *)colorFromInt:(long)intColor
{
    long alpha = (intColor >> 24) & 0x000000FF;
    long red = (intColor >> 16) & 0x000000FF;
    long green = (intColor >> 8) & 0x000000FF;
    long blue = intColor &0x000000FF;
    return [UIColor colorWithRed:red/kColorRangeTopValue green:green/kColorRangeTopValue blue:blue/kColorRangeTopValue alpha:alpha];
}
+ (UIColor *)colorFromHex:(long)intColor
{
    long red = (intColor >> 16) & 0x000000FF;
    long green = (intColor >> 8) & 0x000000FF;
    long blue = intColor &0x000000FF;
    return [UIColor colorWithRed:red/kColorRangeTopValue green:green/kColorRangeTopValue blue:blue/kColorRangeTopValue alpha:1];
}
+ (UIColor *)colorWithRed:(float)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/kColorRangeTopValue green:green/kColorRangeTopValue blue:blue/kColorRangeTopValue alpha:alpha];
}
+ (UIColor *)colorWithRed:(float)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red/kColorRangeTopValue green:green/kColorRangeTopValue blue:blue/kColorRangeTopValue alpha:1];
}
@end
