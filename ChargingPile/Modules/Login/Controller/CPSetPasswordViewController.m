//
//  CPSetPasswordViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPSetPasswordViewController.h"
#import "CPLoginViewController.h"
#import "CPAccountViewController.h"
#import "CMPAccount.h"

#import "CPRegisterTableViewCell.h"
#import "CPLoginServer.h"
#import "BeRegularExpressionUtil.h"


#define kField1Tag 9999
#define kField2Tag 9998
#define kUnableAlpha 0.5

#define kPlaceHolder1 @"请输入您的姓名"
#define kPlaceHolder2 @"请输入密码"
#define kPlaceHolder3 @"请输入手机号码"
#define kPlaceHolder4 @"请输入验证码"

@interface CPSetPasswordViewController ()
{
    NSString *password1;
    NSString *password2;
    UIButton *inquireButton;
}

@end

@implementation CPSetPasswordViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sourceType == CPRegisterVCTypeRegister?@"设置密码":@"重置密码";
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, kScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"下一步" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}
- (void)inquireAction
{
    if(self.sourceType == CPRegisterVCTypeRegister)
    {
        if(password1.length > 20)
        {
            [MBProgressHUD showError:@"姓名过长，请重新输入"];
            return;
        }
        [[ServerFactory getServerInstance:@"CPLoginServer"]doRegisterWithUsername:self.phone andName:password1 andPassword:password2 andSuccess:^(NSDictionary *callback)
         {
             NSLog(@"注册 = %@",callback);
             [CMPAccount sharedInstance].accountInfo.isLogin = YES;
             [CMPAccount sharedInstance].accountInfo.uid = [callback stringValueForKey:@"uid" defaultValue:@""];
             [CMPAccount sharedInstance].accountInfo.loginTelephone = self.phone;
             [CMPAccount sharedInstance].accountInfo.name = [callback stringValueForKey:@"name" defaultValue:@""];
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLoginSuccess object:nil];
             
             
          //   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
             
             CPAccountViewController *accountVC = [[CPAccountViewController alloc]init];
             accountVC.isRegister = YES;
             [self.navigationController pushViewController:accountVC animated:YES];
          //   UIViewController *viewController = [self getNavigationHistoryVC:[CPLoginViewController class]];
          //   [self.navigationController popToViewController:viewController animated:YES];
         }andFailure:^(NSString *error)
         {
             
         }];
    }
    else
    {
        //重置密码 返回2的情况，用户不存在
        [[ServerFactory getServerInstance:@"CPLoginServer"]doResetPasswordWithPhone:self.phone andPassword:password1 andCode:self.code andSuccess:^(NSDictionary *callback)
         {
             NSLog(@"重置密码 = %@",callback);
             UIViewController *viewController = [self getNavigationHistoryVC:[CPLoginViewController class]];
             [self.navigationController popToViewController:viewController animated:YES];
         }andFailure:^(NSString *error)
         {
             
         }];
    }
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    if(noti!=nil)
    {
        UITextField *tf = (UITextField *)[noti object];
        if(tf.tag == kField1Tag)
        {
            password1 = tf.text;
        }
        else if(tf.tag == kField2Tag)
        {
            password2 = tf.text;
        }
    }
    if(self.sourceType == CPRegisterVCTypeRegister)
    {
        if([password1 length]==0 || [password2 length]==0)
        {
            inquireButton.enabled = NO;
            inquireButton.alpha = kUnableAlpha;
        }
        else
        {
            inquireButton.enabled = YES;
            inquireButton.alpha = 1;
        }
    }
    else
    {
        if([password1 length]==0)
        {
            inquireButton.enabled = NO;
            inquireButton.alpha = kUnableAlpha;
        }
        else
        {
            inquireButton.enabled = YES;
            inquireButton.alpha = 1;
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceType == CPRegisterVCTypeRegister?2:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.codeButton.hidden = YES;
        cell.tf.text = password1;
        cell.tf.tag = kField1Tag;
        cell.tf.secureTextEntry = self.sourceType == CPRegisterVCTypeRegister?NO:YES;
        cell.tf.placeholder = self.sourceType == CPRegisterVCTypeRegister?kPlaceHolder1:kPlaceHolder2;
        return cell;
    }
    else{
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.codeButton.hidden = YES;
        cell.tf.text = password2;
        cell.tf.tag = kField2Tag;
        cell.tf.secureTextEntry = YES;
        cell.tf.placeholder = self.sourceType == CPRegisterVCTypeRegister?kPlaceHolder2:kPlaceHolder4;
        return cell;
    }
    return nil;
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

