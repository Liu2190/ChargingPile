//
//  CPChargeListModel.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPChargeListModel : NSObject
@property (nonatomic,strong)NSString *payBy;
@property (nonatomic,strong)NSString *chargeTime;
@property (nonatomic,strong)NSString *chargeDisplayTime;
@property (nonatomic,strong)NSString *amount;
- (id)initWith:(NSDictionary *)member;
@end
