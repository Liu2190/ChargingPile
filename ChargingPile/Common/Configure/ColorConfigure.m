//
//  ColorConfigure.m
//  chargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "ColorConfigure.h"

@implementation ColorConfigure

+ (UIColor *)navTitleColor
{
    return [UIColor whiteColor];
}
+ (UIColor *)navShadowColor
{
    return [ColorUtility colorFromInt:0xff123416];
}
+ (UIColor *)navBarColor
{
    return [ColorUtility colorWithRed:62 green:134 blue:228];
}
+ (UIColor *)cellTitleColor
{
    return [ColorUtility colorFromInt:0xff000000];
}
+ (UIColor *)cellContentColor
{
    return [ColorUtility colorFromInt:0xff999999];
}
+ (UIColor *)cellTimeColor
{
    return [ColorUtility colorFromInt:0xff999999];
}
+ (UIColor *)cellRedDotColor
{
    return [ColorUtility colorWithRed:251 green:67 blue:54];
}
+ (UIColor *)cellMarkTitleColor
{
    return [ColorUtility colorWithRed:251 green:34 blue:51];
}
+ (UIColor *)loginButtonColor
{
    return [ColorUtility colorFromInt:0xffec9f1d];
}
+ (UIColor *)unableButtonColor
{
    return [ColorUtility colorFromInt:0xffec9f1d];
}
+ (UIColor *)textFieldPlaceHolderColor
{
    return [ColorUtility colorWithRed:130.0 green:130.0 blue:130.0];
}
+ (UIColor *)hotelButtonColor
{
    return [ColorConfigure lightGreenColor];
}

+ (UIColor *)lineGrayColor
{
    return [ColorUtility colorWithRed:240 green:240 blue:240];
}
+ (UIColor *)lightGreenColor
{
    return [ColorUtility colorFromHex:0x32cbb6];
}
+ (UIColor *)globalGreenColor
{
    return [ColorUtility colorWithRed:0 green:180 blue:127];
}
+ (UIColor *)globalBlueColor
{
    return [ColorUtility colorFromHex:0x27afe3];
}
+ (UIColor *)globalRedColor
{
    return [ColorUtility colorWithRed:182 green:0 blue:24];
}
+ (UIColor *)globalTextColor
{
    return [ColorUtility colorWithRed:35 green:35 blue:35];
}
+ (UIColor *)globalLineColor
{
    return [ColorUtility colorWithRed:215 green:215 blue:215];
}
@end
