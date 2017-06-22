//
//  CPLoginViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CPResetPasswordViewController.h"
#import "CPRegisterViewController.h"

#import "CPLoginView.h"
#import "CPLoginServer.h"
#import "BeRegularExpressionUtil.h"
#import "CMPAccount.h"
#import "NSDictionary+Additions.h"

@interface CPLoginViewController ()<UITextFieldDelegate>
{
    CPLoginView *bg1;
}

@end

@implementation CPLoginViewController
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
    self.tableView.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50, 0, 100, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePageTitle"]];
    titleView.centerX = view.width/2.0;
    titleView.centerY = view.height/2.0;
    [view addSubview:titleView];
    self.navigationItem.titleView = view;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navImage"]];
    // Do any additional setup after loading the view.
    
    UIImageView *loginBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginBg"]];
    loginBg.centerX = kScreenW/2.0;
    loginBg.y = 40;
    [self.view addSubview:loginBg];
    
    bg1 = [[CPLoginView alloc]initWithFrame:CGRectMake(0, 200, kScreenW, kScreenH - 200 - 64 - 49)];
    bg1.loginNameTF.delegate = self;
    [bg1.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [bg1.registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [bg1.identifyCodeBtn addTarget:self action:@selector(passwordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bg1];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(bg1.loginNameTF == textField)
    {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger length = textField.text.length + string.length - range.length;
        return length <= 11;
    }
    return YES;
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    if(noti!=nil)
    {
        UITextField *tf = (UITextField *)[noti object];
        if(tf == bg1.loginNameTF)
        {
            if(tf.text.length == 11 && ![BeRegularExpressionUtil validateMobile:tf.text])
            {
                [MBProgressHUD showError:@"请输入正确格式的手机号码"];
            }
        }
    }
}
- (void)loginAction
{
    if(bg1.loginNameTF.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if(![BeRegularExpressionUtil validateMobile:bg1.loginNameTF.text])
    {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请输入正确格式的手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }
    if(bg1.passwordTF.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    [[ServerFactory getServerInstance:@"CPLoginServer"]doLoginWithUsername:bg1.loginNameTF.text andPassword:bg1.passwordTF.text andSuccess:^(NSDictionary *callback)
     {
         NSLog(@"登录 = %@",callback);
         if( [[callback stringValueForKey:@"state" defaultValue:@""] intValue] == 1)
         {
             [MBProgressHUD showError:@"姓名或密码错误"];
             return;
         }
         [[CMPAccount sharedInstance].accountInfo setDataWithDic:@{}];
         [CMPAccount sharedInstance].accountInfo.isLogin = YES;
         [CMPAccount sharedInstance].accountInfo.uid = [callback stringValueForKey:@"uid" defaultValue:@""];
         [CMPAccount sharedInstance].accountInfo.loginTelephone = bg1.loginNameTF.text;
         [CMPAccount sharedInstance].accountInfo.name = [callback stringValueForKey:@"name" defaultValue:@""];
         [self getInfo];
         [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLoginSuccess object:nil];
         [self.navigationController dismissViewControllerAnimated:YES completion:nil];
     }andFailure:^(NSString *error)
     {
         [MBProgressHUD showError:@"登录失败"];
     }];
}
- (void)getInfo
{
    [[ServerFactory getServerInstance:@"CPLoginServer"]doGetUserInfoWithSuccess:^(NSDictionary *callback)
     {
         NSLog(@"获取用户信息 = %@",callback);
         [[CMPAccount sharedInstance].accountInfo setDataWithDic:callback];
         [self.tableView reloadData];
     }andFailure:^(NSString *error)
     {
         NSLog(@"获取用户信息失败 = %@",error);
     }];
}
- (void)registerAction
{
    CPRegisterViewController *registerVC = [[CPRegisterViewController alloc]init];
  //  registerVC.sourceType = CPRegisterVCTypeRegister;
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)passwordAction
{
    CPResetPasswordViewController *registerVC = [[CPResetPasswordViewController alloc]init];
    registerVC.sourceType = CPRegisterVCTypePassword;
    [self.navigationController pushViewController:registerVC animated:YES];
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
