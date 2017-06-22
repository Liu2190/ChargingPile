//
//  CPChargeServer.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/24.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPChargeServer : NSObject
/**
 * 启动充电
 */
- (void)doStartChargeWithPileNo:(NSString *)pileNo andMoney:(NSString *)money andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 获取充电信息
 */
- (void)doGetChargeInfoWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 停止充电信息
 */
- (void)doStopWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 停止之后，获取信息
 */
- (void)doGetChargeResultWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 启动充电结果查询
 */
- (void)doInquireStartChargeResultWithOrderId:(NSString *)orderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 停止充电结果查询
 */
- (void)doInquireStopChargeResultWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
@end
