//
//  CPMyPileDetailModel.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDetailModel.h"
#import "NSDictionary+Additions.h"

@implementation CPMyPileDetailModel
- (id)init
{
    if(self = [super init])
    {
        _pileId = @"";
        _no = @"";
        _name = @"";
        _serveDays = @"";
        _serveTimeBegin = @"";
        _serveTimeEnd = @"";
        _feeJ = @"";
        _feeF = @"";
        _feeP = @"";
        _feeG = @"";
        _types = @"";
        _power = @"";
        _voltage = @"";
        _electricity = @"";
        _stationName = @"";
        _address = @"";
        _userName = @"";
        _phone = @"";
        _photos = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)setDataWith:(NSDictionary *)dict
{
    /*
     详情 = 
     {address = "<null>";
     billingModel = "<null>";
     brokenCode = "<null>";
     brokenLevel = "<null>";
     brokenTime = "<null>";
     city = "<null>";
     cityName = "<null>";
     contact = "<null>";
     createTime = 1476518365000;
     district = "<null>";
     districtName = "<null>";
     electricity = 123;
     feeF = 123;
     feeG = 123;
     feeJ = 123;
     feeP = 123;
     id = 4;
     isBroken = 0;
     isBusy = 0;
     isDeleted = 0;
     lat = "<null>";
     lng = "<null>";
     name = APrettyStation;
     no = 1476518365892;
     online = 0;
     phone = 13900000000;
     photos =     (
     {
     id = 4;
     path = "D:/upload/images/2016/10/1476518365908.png";
     pileId = 4;
     },
     {
     id = 5;
     path = "D:/upload/images/2016/10/1476518365923.png";
     pileId = 4;
     }
     );
     power = 123;
     province = "<null>";
     provinceName = "<null>";
     serveDays = "<null>";
     serveTimeBegin = "<null>";
     serveTimeEnd = "<null>";
     station = "<null>";
     stationId = "<null>";
     stationName = "<null>";
     status = 0;
     types = 0;
     userId = 17;
     userName = Fiona;
     voltage = 123;
     */
    _pileId = [dict stringValueForKey:@"id"];
    _no = [dict stringValueForKey:@"no"];
    _name = [dict stringValueForKey:@"name"];
    _serveDays = [dict stringValueForKey:@"serveDays"];
    _serveTimeBegin = [dict stringValueForKey:@"serveTimeBegin"];
    _serveTimeEnd = [dict stringValueForKey:@"serveTimeEnd"];
    _feeJ = [dict stringValueForKey:@"feeJ" defaultValue:@"0"];
    _feeF = [dict stringValueForKey:@"feeF" defaultValue:@"0"];
    _feeP = [dict stringValueForKey:@"feeP" defaultValue:@"0"];
    _feeG = [dict stringValueForKey:@"feeG" defaultValue:@"0"];
    _types = [dict stringValueForKey:@"types"];
    _power = [dict stringValueForKey:@"power" defaultValue:@"0"];
    _voltage = [dict stringValueForKey:@"voltage" defaultValue:@"0"];
    _electricity = [dict stringValueForKey:@"electricity" defaultValue:@"0"];
    _stationName = [dict stringValueForKey:@"stationName"];
    _address = [dict stringValueForKey:@"address"];
    _stationId = [dict stringValueForKey:@"stationId"];
    _userName = [dict stringValueForKey:@"userName"];
    _phone = [dict stringValueForKey:@"phone"];
    _status = [dict stringValueForKey:@"status"];
    _rejectReason = [dict stringValueForKey:@"rejectReason"];
    for(NSDictionary *photoDict in [dict arrayValueForKey:@"photos"])
    {
        [_photos addObject:[photoDict stringValueForKey:@"id"]];
    }
    [self setDisplayTimeData];
}
- (void)setDisplayTimeData
{
    NSArray*titleArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    _displayTime = @"";
    if([_serveDays length] > 1)
    {
        NSArray *days = [_serveDays componentsSeparatedByString:@","];
        for(int i = 0;i<days.count;i++)
        {
            NSString *member = days[i];
            if([member length] > 0 && (![member isEqualToString:@","]) && (![member isEqualToString:@" "]))
            {
                _displayTime = [_displayTime stringByAppendingString:[titleArray objectAtIndex:([member intValue]-1)]];
                if(i != (days.count - 1))
                {
                    _displayTime = [_displayTime stringByAppendingString:@","];
                }
            }
        }
    }
    if([_serveTimeBegin length] > 1)
    {
        _displayTime = [_displayTime stringByAppendingString:[NSString stringWithFormat:@" %@",_serveTimeBegin]];
    }
    if([_serveTimeEnd length] > 1)
    {
        _displayTime = [_displayTime stringByAppendingString:[NSString stringWithFormat:@"-%@",_serveTimeEnd]];
    }
}
@end
