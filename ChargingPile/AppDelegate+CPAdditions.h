//
//  AppDelegate+CPAdditions.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/13.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "AppDelegate.h"
#import "CPRechargeViewController.h"

#import "ServerAPI.h"
#import "CMPAccount.h"
#import "CPAlertView.h"
#import "NSDictionary+Additions.h"
@interface AppDelegate (CPAdditions)
/**
 * 支付宝充值
 */
- (void)aliPayActionWithResult:(NSDictionary *)result;

- (void)payToServerWithType:(CPRechargeSelectedType )selectType andPrice:(NSString *)priceString;
- (void)showFailAlert;
@end
