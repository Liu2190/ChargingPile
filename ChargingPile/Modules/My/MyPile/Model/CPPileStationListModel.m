//
//  CPPileStationListModel.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/17.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileStationListModel.h"
#import "NSDictionary+Additions.h"

@implementation CPPileStationListModel
- (id)initWithDict:(NSDictionary *)dict{
    if(self = [super init])
    {
        _address = [dict stringValueForKey:@"address"];
        _stationId = [dict stringValueForKey:@"id"];
        _name = [dict stringValueForKey:@"name"];
    }
    return self;
}
@end
