//
//  AppDelegate+CPAdditions.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/13.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "AppDelegate+CPAdditions.h"

@implementation AppDelegate (CPAdditions)
- (void)aliPayActionWithResult:(NSDictionary *)result
{
    if([result intValueForKey:@"resultStatus"] !=9000)
    {
        //支付失败
        [self showFailAlert];
    }
    else
    {
        [self payToServerWithType:CPRechargeSelectedTypeAlipay andPrice:self.chargePriceString];
    }
}
- (void)showFailAlert
{
    [[CPAlertView sharedInstance]showViewWithTitle:@"支付" andContent:@"充值失败！" andBlock:^{
    }];
}
- (void)payToServerWithType:(CPRechargeSelectedType )selectType andPrice:(NSString *)priceString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/recharge/api/add",kServerHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"amount"] = [priceString mutableCopy];
    params[@"payBy"] = selectType == CPRechargeSelectedTypeWechat?@"1":@"0";
    if([CMPAccount sharedInstance].accountInfo.payAccount != nil && [[CMPAccount sharedInstance].accountInfo.payAccount length] > 0)
    {
        params[@"payAccount"] = [CMPAccount sharedInstance].accountInfo.payAccount;
    }
    else
    {
        params[@"payAccount"] = @"";
    }
    [MBProgressHUD showMessage:@""];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         [MBProgressHUD hideHUD];
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChargeSuccess  object:nil];
             [[CPAlertView sharedInstance]showViewWithTitle:@"支付" andContent:@"充值成功！" andBlock:^{
                 UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
                 if([topViewController isKindOfClass:[CPRechargeViewController class]])
                 {
                     [topViewController.navigationController popViewControllerAnimated:YES];
                 }
             }];
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [[CPAlertView sharedInstance]showViewWithTitle:@"支付" andContent:@"充值失败！" andBlock:^{
         }];
     }];
}

@end
