//
//  CPRechargeViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"

typedef NS_ENUM(NSInteger,CPRechargeSelectedType) {
    CPRechargeSelectedTypeNone,
    CPRechargeSelectedTypeWechat,
    CPRechargeSelectedTypeAlipay,
};
@interface CPRechargeViewController : CPBaseTableViewController

@end
