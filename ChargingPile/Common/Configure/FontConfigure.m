//
//  FontConfigure.m
//  sbh
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "FontConfigure.h"

@implementation FontConfigure

+ (UIFont *)navTitleFont
{
    return [UIFont fontWithName:kCommonFont size:kNavTitleSize];
}
+ (UIFont *)navButtonItemFont
{
    return [UIFont fontWithName:kIconFont size:kNavButtonItemSize];
}

+ (UIFont *)homeIconItemFont
{
    return [UIFont fontWithName:kIconFont size:kHomeIconItemSize];
}

+ (UIFont *)commonFont:(CGFloat)font
{
    return [UIFont fontWithName:kCommonFont size:font];
}
//cell
+ (UIFont *)cellTitleFont
{
    return [UIFont fontWithName:kCommonFont size:cellTitleSize];
}
+ (UIFont *)cellContentFont
{
    return [UIFont fontWithName:kCommonFont size:cellContentSize];
}
+ (UIFont *)cellTitleLargeFont
{
    return [UIFont fontWithName:kCommonFont size:cellLargeSize];
}
@end
