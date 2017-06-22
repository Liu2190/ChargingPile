//
//  CPOrderListModel.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPOrderListModel.h"
#import "NSDictionary+Additions.h"

@implementation CPOrderListModel
- (id)initWith:(NSDictionary *)dict
{
    if(self = [super init])
    {
        /*
         电桩订单数据
         orderNo	订单号
         pileName	桩名
         address	桩位置
         price	价格
         time	充电时间
         amount	充电金额
         qty	充电电量
         */
        _time = [dict stringValueForKey:@"time"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_time doubleValue]/1000];
        _displayTime = _time;// [formatter stringFromDate:confromTimesp];
        _orderNo = [dict stringValueForKey:@"orderNo"];
        _pileName = [dict stringValueForKey:@"pileName"];
        _address = [dict stringValueForKey:@"address"];
        _price = [dict stringValueForKey:@"price"];
        _orderIncome = [NSString stringWithFormat:@"￥%@",[dict stringValueForKey:@"earnings" defaultValue:@"0.0"]];
        _amount = [NSString stringWithFormat:@"￥%@",[dict stringValueForKey:@"amount" defaultValue:@"0.0"]];
        _qty = [NSString stringWithFormat:@"%@kwh",[dict stringValueForKey:@"qty"]];
    }
    return self;
}
- (void)setType:(OrderListModelType)type
{
    _type = type;
    switch (type) {
        case OrderListModelTypeUser:
            _orderStatus = @"已完成";
            break;
        case OrderListModelTypePileOwnerWJS:
            _orderStatus = @"未结算";
            break;
        case OrderListModelTypePileOwnerYJS:
            _orderStatus = @"已结算";
            break;
        default:
            break;
    }
}
@end
