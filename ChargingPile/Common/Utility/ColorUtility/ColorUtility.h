//
//  ColorUtility.h
//  chargingPile
//
//  Created by chargingPile on 15/1/27.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorUtility : NSObject

+ (UIColor *)colorFromInt:(long)intColor;//例如0xFF010203
+ (UIColor *)colorFromHex:(long)intColor;//例如0x010203
+ (UIColor *)colorWithRed:(float)red green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+ (UIColor *)colorWithRed:(float)red green:(CGFloat)g blue:(CGFloat)b;
@end
