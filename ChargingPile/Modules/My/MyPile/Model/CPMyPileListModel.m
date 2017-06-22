//
//  CPMyPileListModel.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileListModel.h"
#import "NSDictionary+Additions.h"

@implementation CPMyPileListModel
- (id)initWith:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _pileId = [dict stringValueForKey:@"id"];
        _stationName = [dict stringValueForKey:@"stationName"];
        _pileName = [dict stringValueForKey:@"name"];
        _address = [dict stringValueForKey:@"address"];
        _createTime = [dict stringValueForKey:@"createTime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_createTime doubleValue]/1000];
        _displayTime = [formatter stringFromDate:confromTimesp];
        
        switch ([[dict stringValueForKey:@"status"] intValue]) {
            case 0:
                _status = @"审核中";
                break;
            case 1:
                _status = @"通过";

                break;
            case 2:
                _status = @"未通过";
                break;
                
            default:
                _status = @"通过";
                break;
        }
    }
    return self;
}
@end
