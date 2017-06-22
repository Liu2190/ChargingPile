//
//  DateFormatterConfig.h
//  chargingPile
//
//  Created by chargingPile on 15/1/29.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatterConfig : NSDateFormatter
@property (nonatomic,assign)BOOL timeIs24HourFormat;

+ (DateFormatterConfig *)sharedFormatter;
+ (NSString *)getCurrentDate;
+ (NSString *)naturalStringFromDate:(NSDate *)date;
+ (NSString *)naturalStringFromTimeStamp:(time_t)timeStamp;
+ (NSString *)naturalStringFromTimeStamp:(time_t)timeStamp truncateTime:(BOOL)truncate;
+ (NSString *)dateStringFromDate:(NSDate *)date;
+ (NSString *)dateStringFromDateString:(NSString *)dateString;
@end
