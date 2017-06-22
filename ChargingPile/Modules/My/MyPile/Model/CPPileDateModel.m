//
//  CPPileDateModel.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/13.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileDateModel.h"
#import "NSDictionary+Additions.h"

@implementation CPPileDateModel
- (id)init
{
    if(self = [super init])
    {
        _dateId = @"";//	时间段id
        _userId = @"";//	用户id
        _days = @"";//	周日到周六分别为1,2,3,4,5,6,7，中间用英文逗号分隔
        _beginTime = @"";//	开始时间
        _endTime = @"";
        _selected = NO;
    }
    return self;
}
- (void)setDataWithDict:(NSDictionary *)dict
{
    _dateId = [dict stringValueForKey:@"id"];
    _userId = [dict stringValueForKey:@"userId"];
    _days = [dict stringValueForKey:@"days"];
    _beginTime = [dict stringValueForKey:@"beginTime"];
    _endTime = [dict stringValueForKey:@"endTime"];
}
@end
