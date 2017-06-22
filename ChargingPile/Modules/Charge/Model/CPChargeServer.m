//
//  CPChargeServer.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/24.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeServer.h"
#import "CPHttp.h"
#import "ServerAPI.h"
#import "NSString+sha256.h"
#import "CMPAccount.h"

@implementation CPChargeServer

/**
 * 启动充电
 */
- (void)doStartChargeWithPileNo:(NSString *)pileNo andMoney:(NSString *)money andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/order/api/start"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"pileNo"] = pileNo;
    parameter[@"money"] = money;
    parameter[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;

    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         NSLog(@"充电成功 = %@",responseObj);
         callback(responseObj);
         
     }failure:^(NSError *error)
     {
         NSLog(@"充电失败 = %@",error);
         failure(error);
     }];
}

/**
 * 获取充电信息
 */
- (void)doGetChargeInfoWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/info/%@",kServerHost,OrderId];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"获取充电信息 = %@",responseObj);
         callback(responseObj);
     }failure:^(NSError *error)
     {
         NSLog(@"获取信息失败 = %@",error);
         failure(error);
     }];
}
/**
 * 停止充电信息
 */
- (void)doStopWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/stop",kServerHost];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"id"] = [NSNumber numberWithInteger:[OrderId integerValue]];
    params[@"userId"] =[CMPAccount sharedInstance].accountInfo.uid;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         NSLog(@"停止成功 = %@",responseObj);
         callback(responseObj);
     }failure:^(NSError *error)
     {
         NSLog(@"停止失败 = %@",error);
         failure(error);
     }];
}
/**
 * 停止之后，获取信息
 */
- (void)doGetChargeResultWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/%@",kServerHost,OrderId];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"停止之后，获取信息 = %@",responseObj);
         callback(responseObj);
     }failure:^(NSError *error)
     {
         NSLog(@"停止之后，获取信息失败 = %@",error);
         failure(error);
     }];
}
/**
 * 启动充电结果查询
 */
- (void)doInquireStartChargeResultWithOrderId:(NSString *)orderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/result/start/%@",kServerHost,orderId];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"启动充电结果查询 = %@",responseObj);
         callback(responseObj);
     }failure:^(NSError *error)
     {
         NSLog(@"启动充电结果查询失败 = %@",error);
         failure(error);
     }];
}
/**
 * 停止充电结果查询
 */
- (void)doInquireStopChargeResultWithOrderId:(NSString *)OrderId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/result/stop/%@",kServerHost,OrderId];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"停止充电结果 = %@",responseObj);
         callback(responseObj);
     }failure:^(NSError *error)
     {
         NSLog(@"停止充电结果失败 = %@",error);
         failure(error);
     }];
}
@end
