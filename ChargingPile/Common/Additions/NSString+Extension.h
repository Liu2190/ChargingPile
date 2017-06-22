//
//  NSString+Extension.h
//  chargingPile
//
//  Created by chargingPile on 15/5/26.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)intervalSinceNow:(NSString *)theDate;

+ (double)getIntervalNow;

// 日期格式的变换
- (NSString *)dateFormatOriginalString:(NSString *)origStr withString:(NSString *)intoStr;

+ (NSString *)md5:(NSString *)str;

// 适配iOS7/iOS8以上版本，判断是否包含字符串
- (BOOL)cmpContainsWithString:(NSString *)str;
@end
