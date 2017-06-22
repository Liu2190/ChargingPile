//
//  CPPilePayAccountViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPilePayAccountViewController.h"
#import "CMPAccount.h"
#import "ServerAPI.h"
#import "ColorConfigure.h"

#define kPlaceHolder @"请输入支付宝账号"

@interface CPPilePayAccountViewController ()
{
    NSString *priceString;
    UITextField *tf;
}

@end

@implementation CPPilePayAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"电桩收款账号";
    priceString = [[NSString alloc]init];
    if([CMPAccount sharedInstance].accountInfo.payAccount.length > 0)
    {
        priceString = [[CMPAccount sharedInstance].accountInfo.payAccount mutableCopy];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textValueChanged) name:UITextFieldTextDidChangeNotification object:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    tf.placeholder = kPlaceHolder;
    tf.text = priceString;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:tf];
    return cell;
}

- (void)textValueChanged
{
    priceString = tf.text;
}
- (void)rightAction
{
    if(priceString.length < 1)
    {
        [MBProgressHUD showError:kPlaceHolder];
        return;
    }
    if([priceString isEqualToString:[CMPAccount sharedInstance].accountInfo.payAccount])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/user/api/setPayAccount",kServerHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"payAccount"] = [priceString mutableCopy];
    [MBProgressHUD showMessage:@""];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         [MBProgressHUD hideHUD];
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             [MBProgressHUD showSuccess:@"设置成功！"];
             [CMPAccount sharedInstance].accountInfo.payAccount =priceString;
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }
         else{
             [MBProgressHUD showError:@"设置失败"];
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"设置失败"];
     }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
