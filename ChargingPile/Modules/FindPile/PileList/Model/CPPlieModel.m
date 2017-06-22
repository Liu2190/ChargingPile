//
//  CPPlieModel.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPlieModel.h"
#import "NSDictionary+Additions.h"

@implementation CPPlieModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        /*
         [{"id":1,"no":"aaa","name":"aaa","contact":"aaa","phone":"aaa","types":0,"userId":5,"lng":116.387108,"lat":39.91544,"province":1,"city":1,"district":3,"address":"","photo":null,"star":2,"provinceName":null,"cityName":null,"districtName":null,"operator":null}]
         */
        _pileId = [dict stringValueForKey:@"id"];
        _no = [dict stringValueForKey:@"no"];
        _name = [dict stringValueForKey:@"name"];
        _contact = [dict stringValueForKey:@"contact"];
        _phone = [dict stringValueForKey:@"phone"];
        _types = [dict stringValueForKey:@"types"];
        if([_types intValue] == 0)
        {
            _dianzhanType = @"公用";
        }
        else if([_types intValue] == 1)
        {
            _dianzhanType = @"专用";
        }
        else if([_types intValue] == 2)
        {
            _dianzhanType = @"私人";
        }
        _userId = [dict stringValueForKey:@"userId"];
        _lng = [dict stringValueForKey:@"lng"];
        _lat = [dict stringValueForKey:@"lat"];
        _province = [dict stringValueForKey:@"province"];
        _city = [dict stringValueForKey:@"city"];
        _district = [dict stringValueForKey:@"district"];
        _address = [dict stringValueForKey:@"address"];
        _star = [dict stringValueForKey:@"star"];
        _provinceName = [dict stringValueForKey:@"provinceName"];
        _cityName = [dict stringValueForKey:@"cityName"];
        _districtName = [dict stringValueForKey:@"districtName"];
        _operatorName = [dict stringValueForKey:@""];
        _icon = [dict stringValueForKey:@""];
        _photo = [dict stringValueForKey:@"photo"];
        _operatorLogo = [dict stringValueForKey:@"operator"];
        _pilePrice = @"¥120";
        _distanceAppearance = @"5000m";
        _isFavor = [dict boolValueForKey:@"isFavored"];
        _idle = [dict stringValueForKey:@"idle"defaultValue:@"0"];
        _idleJiaLiu = [dict stringValueForKey:@"idleJiaLiu" defaultValue:@"0"];
        _idleZhiLiu = [dict stringValueForKey:@"idleZhiLiu"defaultValue:@"0"];
        _jiaoLiu = [dict stringValueForKey:@"jiaoLiu"defaultValue:@"0"];
        _zhiLiu = [dict stringValueForKey:@"zhiLiu"defaultValue:@"0"];
        _jian = [dict stringValueForKey:@"jian"defaultValue:@"0"];
        _feng = [dict stringValueForKey:@"feng"defaultValue:@"0"];
        _ping = [dict stringValueForKey:@"ping"defaultValue:@"0"];
        _gu = [dict stringValueForKey:@"gu"defaultValue:@"0"];
        _feeJ = [dict stringValueForKey:@"feeJ"defaultValue:@"0"];
        _feeF = [dict stringValueForKey:@"feeF"defaultValue:@"0"];
        _feeP = [dict stringValueForKey:@"feeP"defaultValue:@"0"];
        _feeG = [dict stringValueForKey:@"feeG"defaultValue:@"0"];
        NSMutableArray *values = [[NSMutableArray alloc]init];
        for(NSString *key in [dict allKeys])
        {
            NSString *value = [dict valueForKey:key];
            if ([value isKindOfClass:[NSNull class]]||value==nil)
            {
                value = @"";
            }
            if ([value isKindOfClass:[NSString class]])
            {
                value = [value lowercaseString];
                if ([value rangeOfString:@"null"].location!=NSNotFound)
                {
                    value = @"";
                }
            }
            [values addObject:value];
        }
        self.storedDict = [NSDictionary dictionaryWithObjects:values forKeys:[dict allKeys]];
    }
    return self;
}
- (void)getDistanceWithLocation:(CLLocationCoordinate2D )location
{
    if(location.latitude > 0 && location.longitude > 0)
    {
        CLLocation *orig = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        CLLocation* dist = [[CLLocation alloc] initWithLatitude:[_lat doubleValue] longitude:[_lng doubleValue]];
        CLLocationDistance kilometers = [orig distanceFromLocation:dist];
        _distanceAppearance = [NSString stringWithFormat:@"%.0fm",kilometers];
        if(kilometers > 1000)
        {
            _distanceAppearance = [NSString stringWithFormat:@"%.0fkm",kilometers/1000.0];
        }
    }
    else
    {
        _distanceAppearance = @"";
    }
}
@end
