//
//  CPChargeProduceModel.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPChargeProduceModel : NSObject
/**
 * 电流
 */
@property (nonatomic,strong)NSString *electricCurrent;
/**
 * 电压
 */
@property (nonatomic,strong)NSString *voltage;
/**
 * 电量金额
 */
@property (nonatomic,strong)NSString *amountAlectricity;
/**
 * 电量度数
 */
@property (nonatomic,strong)NSString *electricQuantityDegree;


/**
 * 剩余电量百分比
 */
@property (nonatomic,strong)NSString *batteryPercent;

@end
