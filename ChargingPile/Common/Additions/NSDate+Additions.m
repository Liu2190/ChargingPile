//
//  NSDate+Additions.m
//  chargingPile
//
//  Created by chargingPile on 15/1/29.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSInteger)compareWithToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    return [self compareWithTodayWithDateFormatter:formatter];
}
- (NSInteger)compareWithTodayWithDateFormatter:(NSDateFormatter *)dateFormatter
{
    NSDate *today = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormatter stringFromDate:today];
    today  = [dateFormatter dateFromString:todayStr];
    NSInteger interval = (NSInteger)[self timeIntervalSinceDate:today];
    NSInteger intervalDate = 0;
    if(interval <= 0)
    {
        intervalDate = interval/(24*60*60)-1;
    }
    else {
        intervalDate = interval/(24*60*60);
    }
    return intervalDate;
}
@end

