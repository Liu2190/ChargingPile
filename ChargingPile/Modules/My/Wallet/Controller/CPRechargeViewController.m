//
//  CPRechargeViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPRechargeViewController.h"
#import "AppDelegate.h"

#import "CMPAccount.h"
#import "ServerAPI.h"
#import "ColorConfigure.h"
#import "CPAlertView.h"

#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "payRequsestHandler.h"

#define kTip1 @"请输入金额"
#define kTip2 @"请选择充值方式"

@interface CPRechargeViewController ()<UITextFieldDelegate>
{
    CPRechargeSelectedType selectType;
    NSString *priceString;
    UIButton *inquireButton;
    UITextField *tf;
}

@end

@implementation CPRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    selectType = CPRechargeSelectedTypeNone;
    priceString = [[NSString alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textValueChanged) name:UITextFieldTextDidChangeNotification object:nil];
    [self setFooterView];
    [self textValueChanged];
    // Do any additional setup after loading the view.
}

- (void)setFooterView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(80, 28, kScreenW - 160, 45);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"充值" forState:UIControlStateNormal];
    inquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:inquireButton];
    self.tableView.tableFooterView = headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(UITextField *subview in [cell subviews])
        {
            if([subview isKindOfClass:[UITextField class]])
            {
                [subview removeFromSuperview];
            }
        }
        tf = [[UITextField alloc]initWithFrame:CGRectMake(14, 2,kScreenW - 28,46)];
        tf.textColor = [UIColor darkGrayColor];
        tf.font = [UIFont systemFontOfSize:14];
        tf.placeholder = kTip1;
        tf.keyboardType = UIKeyboardTypeDecimalPad;
        tf.text = priceString;
        tf.delegate = self;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell addSubview:tf];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = kTip2;
        return cell;
    }
    else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        for(UIImageView *subview in [cell subviews])
        {
            if([subview isKindOfClass:[UIImageView class]])
            {
                [subview removeFromSuperview];
            }
        }
        if(selectType == CPRechargeSelectedTypeWechat)
        {
            UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
            cellImage.centerY = 22.0f;
            cellImage.centerX = kScreenW - 40;
            [cell addSubview:cellImage];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"微信"];
        cell.textLabel.text = @"微信";
        return cell;
    }
    else if (indexPath.row == 3)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(UIImageView *subview in [cell subviews])
        {
            if([subview isKindOfClass:[UIImageView class]])
            {
                [subview removeFromSuperview];
            }
        }
        if(selectType == CPRechargeSelectedTypeAlipay)
        {
            UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
            cellImage.centerY = 22.0f;
            cellImage.centerX = kScreenW - 40;
            [cell addSubview:cellImage];
        }
        cell.imageView.image = [UIImage imageNamed:@"支付宝"];
        cell.textLabel.text = @"支付宝";
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 2)
    {
        selectType = CPRechargeSelectedTypeWechat;
        [self.tableView reloadData];
    }
    else if (indexPath.row == 3)
    {
        selectType = CPRechargeSelectedTypeAlipay;
        [self.tableView reloadData];
    }
    [self textValueChanged];
}
- (void)textValueChanged
{
    priceString = tf.text;
    if(priceString.length > 0 && selectType != CPRechargeSelectedTypeNone)
    {
        inquireButton.enabled = YES;
        inquireButton.alpha = 1;
    }
    else
    {
        inquireButton.enabled = NO;
        inquireButton.alpha = 0.5;
    }
}
- (void)rechargeAction
{
    if(priceString.length < 1)
    {
        [MBProgressHUD showError:kTip1];
        return;
    }
    if(selectType == CPRechargeSelectedTypeNone)
    {
        [MBProgressHUD showError:kTip2];
        return;
    }
    [AppDelegate appdelegate].chargePriceString = [priceString mutableCopy];
    if(selectType == CPRechargeSelectedTypeWechat)
    {
        [self doWechatPay];
    }
    else
    {
        [self doAlipayPay];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 生成订单号
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
#pragma mark - 微信支付
- (void )doWechatPay
{
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    int price = [priceString floatValue] * 100 ;
    NSMutableDictionary *dict = [req sendPay_demo:@"微信充值" order_price:[NSString stringWithFormat:@"%d",price] orderno:[self generateTradeNO]];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}
#pragma mark - 支付宝支付
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2016070701589393";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKk9jooVTqK1MoseVuk5/4Ch4RUazRRrRaUAg5eCo8oNlWLaTpGwLl4pULk0Q/mQBw2Z3SMCIxa6NvUxMNDCpD/sV+LIgWR1I9RxSxaZHqDaeMycW6Mp2Jbk7jBrrpGNPjkp11o+a60SabThO3g1TsYe7DguanvBd9LJ9k8v/owlAgMBAAECgYADCsI3JS7mqc8gxQjW5F39V+uNz4+EIHF+B8ZVwNlk1l2rCzWCVOJgeumiipf2MmqOCgf5ix5KWEqImbvA5N7C5+b+NocN5g4UbV+kPPX7+/X+Dl3bs6gQocEkxpxvW7Sz8mvhHbT0pXRd3WNTFC7Gvi2ejUdsUU5mIJmffTRNQQJBANF3vrr1OfPZEMxFEYlaXT227k7rxgMyR7YsYQ55ep9NjJzcKchwSQ2PCq0OBrg1gm7HB9odfSl+8TGI2L77Zy0CQQDO1h6BwRlQLtfBscjzd5Aet945dl5X0Gf+/vpyPcn37GczDKzbPIJasRZ7Mv37m+NtIfzY3q9U4ff6tZe6gtPZAkBCK6C98L/I73ZmAR+kEz7HQyWPGt4nnleXDffvGaMJ9faIiuhMIGSDev91Yavvvz+f/RHW7l/envJUopVN559VAkEAiuZaCFMP17wNYmMtCutRGn/puXcXNiubmy/KKmv6NQdJ6otpjbUd6R+hdEyzKYPvf7tiXJV28y7o5DGM2lC/SQJBALMG3t77Vc1ZxD7NoRmNPlHI2qXX4A6y+DVktu6zRPwSqn0LqIUFFJdBdC9f+N1V1Uox5apVJocSdk6kzhwTkZw=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"电桩充值";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.notify_url = @"http://www.xxx.com";
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [priceString floatValue]]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme
        NSString *appScheme = @"iyichong";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *status = [resultDic stringValueForKey:@"resultStatus"];
            if ([status isEqualToString:@"9000"])
            {
                [self payToServer];
            }
            else
            {
                [[CPAlertView sharedInstance]showViewWithTitle:@"支付" andContent:@"充值失败！" andBlock:^{
                }];
            }
        }];
    }
}
- (void)payToServer
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/recharge/api/add",kServerHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"amount"] = [NSNumber numberWithFloat:[priceString floatValue]];
    params[@"payBy"] = selectType == CPRechargeSelectedTypeWechat?@"1":@"0";
    params[@"payAccount"] = @"";
    [MBProgressHUD showMessage:@""];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         [MBProgressHUD hideHUD];
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             [[CPAlertView sharedInstance]showViewWithTitle:@"支付" andContent:@"充值成功！" andBlock:^{
                 [self.navigationController popViewControllerAnimated:YES];
             }];
         }
     }failure:^(NSError *error)
     {
         [[CPAlertView sharedInstance]showViewWithTitle:@"支付" andContent:@"充值失败！" andBlock:^{
         }];
         [MBProgressHUD hideHUD];
     }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound)
    {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt= (int)range.location-(int)ran.location;
                    if (tt <= 2){
                        return YES;
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }
        else
        {//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
