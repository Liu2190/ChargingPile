//
//  CPChargeProduceModel.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeProduceModel.h"

@implementation CPChargeProduceModel

- (id)init
{
    if(self = [super init])
    {
        _electricCurrent = @"";
        _voltage = @"";
        _amountAlectricity = @"";
        _electricQuantityDegree = @"";
        _batteryPercent = @"";
    }
    return self;
}
@end
