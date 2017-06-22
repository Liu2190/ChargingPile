//
//  CPChargeListModel.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeListModel.h"
#import "NSDictionary+Additions.h"

@implementation CPChargeListModel
- (id)initWith:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _payBy = [dict stringValueForKey:@"payBy"];
        _chargeTime = [dict stringValueForKey:@"chargeTime"];
        _amount = [dict stringValueForKey:@"amount"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_chargeTime doubleValue]/1000];
        _chargeDisplayTime = [formatter stringFromDate:confromTimesp];
    }
    return self;
}
@end
