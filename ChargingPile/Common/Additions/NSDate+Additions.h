//
//  NSDate+Additions.h
//  chargingPile
//
//  Created by chargingPile on 15/1/29.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSInteger)compareWithToday;

- (NSInteger)compareWithTodayWithDateFormatter:(NSDateFormatter *)dateFormatter;

@end
