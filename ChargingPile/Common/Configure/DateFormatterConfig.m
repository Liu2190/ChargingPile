//
//  DateFormatterConfig.m
//  chargingPile
//
//  Created by chargingPile on 15/1/29.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "DateFormatterConfig.h"
#import "NSDate+Additions.h"

@implementation DateFormatterConfig

+ (DateFormatterConfig *)sharedFormatter {
    static DateFormatterConfig *dateFormatter = nil;
    
    @synchronized(self) {
        if (dateFormatter == nil) {
            dateFormatter = [[DateFormatterConfig alloc] init];
        }
    }
    return dateFormatter;
}

- (id)init {
    self = [super init];
    if (self) {
        self.timeIs24HourFormat = [self is24HourFormat:self];
    }
    return self;
}
+ (NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
- (BOOL)is24HourFormat:(NSDateFormatter *)formatter {
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    return (amRange.location == NSNotFound && pmRange.location == NSNotFound);
}

- (NSString *)naturalStringFromDate:(NSDate *)date {
    return [self naturalStringFromDate:date truncateTime:NO];
}

- (NSString *)naturalStringFromDate:(NSDate *)date truncateTime:(BOOL)truncate {
    NSString *dateString = nil;
    NSInteger offset = [date compareWithTodayWithDateFormatter:self];
    //明天
    if(offset == 1) {
        self.dateFormat = @"HH:mm";
        if([self stringFromDate:date])
        {
            dateString = [NSString stringWithFormat:@"明天 %@", [self stringFromDate:date]];
        }
        else
        {
            dateString = @"明天";
        }
    }
    //今天
    else if(offset == 0) {
        self.dateFormat = @"HH:mm";
        if([self stringFromDate:date])
        {
            dateString = [NSString stringWithFormat:@"今天 %@", [self stringFromDate:date]];
        }
        else
        {
            dateString = @"今天";
        }
    }
    //昨天
    else if(offset == -1) {
        self.dateFormat = @"HH:mm";
        if([self stringFromDate:date])
        {
           dateString = [NSString stringWithFormat:@"昨天 %@", [self stringFromDate:date]];
        }
        else
        {
            dateString = @"昨天";
        }
    }
    //其它
    else {
        self.dateFormat = @"yyyy";
        NSString *old = [self stringFromDate:date];
        NSString *now = [self stringFromDate:[NSDate date]];
        if ([old isEqualToString:now]) {
            self.dateFormat = @"M月d日 HH:mm";
            //self.dateFormat = @"M月d日";

        } else {
            if (truncate) {
                self.dateFormat = @"yyyy年M月d日";
            } else {
                self.dateFormat = @"yyyy年M月d日 HH:mm";
            }
        }
        dateString = [NSString stringWithFormat:@"%@", [self stringFromDate:date]];
    }
    return dateString;
}
- (NSString *)naturalStringFromTimeStamp:(time_t)timeStamp {
    return [self naturalStringFromTimeStamp:timeStamp truncateTime:NO];
}
- (NSString *)naturalStringFromTimeStamp:(time_t)timeStamp truncateTime:(BOOL)truncate {
    NSString *naturalString = nil;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, timeStamp);
    if (distance < 60 && distance >= 0) {
        naturalString = @"刚刚";
    }
    else if (distance < 60 * 60 && distance > 0) {
        distance = distance / 60;
        naturalString = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }
    else {
        return [self naturalStringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp] truncateTime:truncate];
    }
    return naturalString;
}

+ (NSString *)naturalStringFromDate:(NSDate *)date {
    return [[DateFormatterConfig sharedFormatter] naturalStringFromDate:date];
}

+ (NSString *)naturalStringFromTimeStamp:(time_t)timeStamp {
    return [[DateFormatterConfig sharedFormatter] naturalStringFromTimeStamp:timeStamp];
}

+ (NSString *)naturalStringFromTimeStamp:(time_t)timeStamp truncateTime:(BOOL)truncate {
    return [[DateFormatterConfig sharedFormatter] naturalStringFromTimeStamp:timeStamp truncateTime:truncate];
}

+ (NSString *)dateStringFromDate:(NSDate *)date;
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *todate = [NSDate date];
    [[NSDate date] timeIntervalSince1970];
    formatter.dateFormat = @"yyyy年M月d日 HH:mm:ss";
    return [formatter stringFromDate:todate];
}

+ (NSString *)dateStringFromTimeStamp:(time_t)timeStamp {
    return @"";
}

+ (NSString *)dateStringFromDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if([dateString rangeOfString:@"/"].location != NSNotFound)
    {
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:dateString];
    time_t timeSp = [date timeIntervalSince1970];
    return [[DateFormatterConfig sharedFormatter]naturalStringFromTimeStamp:timeSp];
}
@end
