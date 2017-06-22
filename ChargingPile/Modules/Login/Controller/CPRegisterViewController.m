//
//  CPRegisterPasswordViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/10.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import "CPRegisterViewController.h"
#import "CPLoginViewController.h"
#import "CPAccountViewController.h"
#import "CMPAccount.h"

#import "CPLoginServer.h"
#import "CPRegisterTableViewCell.h"
#import "BeRegularExpressionUtil.h"

#define kField1Tag 9999
#define kField2Tag 9998
#define kUnableAlpha 0.5

#define kPlaceHolder1 @"请输入密码"
#define kPlaceHolder2 @"请确认密码"

#define kPhoneFieldTag 99999
#define kCodeFieldTag 88888
//最大秒数间隔
#define kMaxMargin 10
#define kUnableAlpha 0.5

@interface CPRegisterViewController ()<UITextFieldDelegate>
{
    NSString *phone;
    NSString *code;
    
    int timeIndex;
    NSTimer *myTimer;
    
    NSString *countBackString;
    UIButton *inquireButton;
    
    NSString *password1;
    NSString *password2;
}

@end

@implementation CPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    timeIndex = kMaxMargin;
    countBackString = @"验证码";
    phone = [[NSString alloc]init];
    code = [[NSString alloc]init];
    self.title = @"注册";
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, kScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"注册" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
    [self textFieldValueChanged:nil];
    // Do any additional setup after loading the view.
}
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
#pragma mark - 注册
- (void)inquireAction
{
    if(password1.length > 20)
    {
        [MBProgressHUD showError:@"密码过长，请重新输入"];
        return;
    }
    if(![password1 isEqualToString:password2])
    {
        [MBProgressHUD showError:@"密码输入不一致，请重新输入"];
        return;
    }
    [[ServerFactory getServerInstance:@"CPLoginServer"]doCheckSMSVerificationCodeWith:phone andCode:code andSuccess:^(NSDictionary *callback)
     {
         if( [[callback stringValueForKey:@"state" defaultValue:@""] intValue] == 1)
         {
             [MBProgressHUD showError:@"短信校验失败"];
             return;
         }
         [MBProgressHUD showMessage:@""];
         [[ServerFactory getServerInstance:@"CPLoginServer"]doRegisterWithUsername:phone andName:password1 andPassword:password2 andSuccess:^(NSDictionary *callback)
          {
              [MBProgressHUD hideHUD];
              NSLog(@"注册 = %@",callback);
              if( [[callback stringValueForKey:@"state" defaultValue:@""] isEqualToString:@"-1"])
              {
                  [MBProgressHUD showError:@"该号码已注册，请返回登录或者找回密码"];
                  return;
              }
              if( [[callback stringValueForKey:@"state" defaultValue:@""] isEqualToString:@"1"])
              {
                  [MBProgressHUD showError:@"注册失败"];
                  return;
              }
              [[CMPAccount sharedInstance].accountInfo setDataWithDic:@{}];
              [CMPAccount sharedInstance].accountInfo.isLogin = YES;
              [CMPAccount sharedInstance].accountInfo.uid = [callback stringValueForKey:@"uid" defaultValue:@""];
              [CMPAccount sharedInstance].accountInfo.loginTelephone = phone;
              [CMPAccount sharedInstance].accountInfo.name = [callback stringValueForKey:@"name" defaultValue:@""];
              [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLoginSuccess object:nil];
              CPAccountViewController *accountVC = [[CPAccountViewController alloc]init];
              accountVC.isRegister = YES;
              [self.navigationController pushViewController:accountVC animated:YES];
          }andFailure:^(NSString *error)
          {
              [MBProgressHUD hideHUD];
              [MBProgressHUD showError:@"注册失败，用户已存在"];
              return;
          }];
     }andFailure:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"短信校验失败"];
         return;
     }];
}
#pragma mark - 查看用户是否存在
- (void)checkUserExist
{
    [[ServerFactory getServerInstance:@"CPLoginServer"]checkPhoneIsRegisteredWithUserName:phone andSuccess:^(NSDictionary *callback)
     {
         NSLog(@"注册是否有重复 = %@",callback);
         if( [[callback stringValueForKey:@"state" defaultValue:@""] intValue] == 0 && [[callback stringValueForKey:@"exists" defaultValue:@""] intValue] == 1)
         {
             [MBProgressHUD showError:@"该号码已注册，请返回登录或者找回密码"];
         }
     }andFailure:^(NSString *error)
     {
     }];
}
#pragma mark- 获取验证码
- (void)getCodeAction
{
    if(![BeRegularExpressionUtil validateMobile:phone])
    {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请输入正确格式的手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }
    if(timeIndex == kMaxMargin)
    {
        [self countBackwards];
        [[ServerFactory getServerInstance:@"CPLoginServer"]doGetSMSVerificationCodeWith:phone andSuccessCallback:^(NSDictionary *callback)
         {
             
         }andFailureCallback:^(NSString *error)
         {
             
         }];
    }
}
#pragma mark - 秒数倒计时
- (void)countBackwards
{
    timeIndex --;
    if(timeIndex == 0)
    {
        countBackString = @"重新获取";
        [myTimer invalidate];
        timeIndex = kMaxMargin;
    }
    else
    {
        countBackString = [NSString stringWithFormat:@"获取验证码（%ds）",timeIndex];
        [self addTimer];
    }
    CPRegisterTableViewCell *cell = (CPRegisterTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];;
    [cell.codeButton setTitle:countBackString forState:UIControlStateNormal];
    [self textFieldValueChanged:nil];
}
- (void)addTimer
{
    [myTimer invalidate];
    myTimer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(countBackwards)userInfo:nil repeats:NO];
    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == kPhoneFieldTag)
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
        if(tf.tag == kPhoneFieldTag)
        {
            phone = tf.text;
            if(phone.length == 11)
            {
                if(![BeRegularExpressionUtil validateMobile:phone])
                {
                    [MBProgressHUD showError:@"请输入正确格式的手机号码"];
                }
                else
                {
                    [self checkUserExist];
                }
            }
        }
        else if(tf.tag == kCodeFieldTag)
        {
            code = tf.text;
        }
        else if(tf.tag == kField1Tag)
        {
            password1 = tf.text;
        }
        else if(tf.tag == kField2Tag)
        {
            password2 = tf.text;
        }
    }
    
    CPRegisterTableViewCell *cell2 = (CPRegisterTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];;
    
    if([phone length]==0 || [code length]==0)
    {
        inquireButton.enabled = NO;
        inquireButton.alpha = kUnableAlpha;
    }
    else
    {
        inquireButton.enabled = YES;
        inquireButton.alpha = 1;
    }
    if(timeIndex == kMaxMargin && [phone length] > 0)
    {
        cell2.codeButton.alpha = 1;
        cell2.codeButton.enabled = YES;
    }
    else
    {
        cell2.codeButton.alpha = kUnableAlpha;
        cell2.codeButton.enabled = NO;
    }
    
    
    if([password1 length]==0 || [password2 length]==0 || [phone length]==0 || [code length]==0)
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.codeButton.hidden = YES;
        cell.tf.tag = kPhoneFieldTag;
        cell.tf.keyboardType = UIKeyboardTypePhonePad;
        cell.tf.delegate = self;

        cell.tf.text = phone;
        cell.tf.placeholder = @"请输入手机号";
        return cell;
    }
    else if(indexPath.row == 1)
    {
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.codeButton.hidden = YES;
        cell.tf.text = password1;
        cell.tf.tag = kField1Tag;
        cell.tf.secureTextEntry = YES;
        cell.tf.placeholder = kPlaceHolder1;
        return cell;
    }
    else if(indexPath.row == 2){
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.codeButton.hidden = YES;
        cell.tf.text = password2;
        cell.tf.tag = kField2Tag;
        cell.tf.secureTextEntry = YES;
        cell.tf.placeholder = kPlaceHolder2;
        return cell;
    }
    else{
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.tf.placeholder = @"请输入验证码";
        cell.tf.width = kScreenW - 170;
        if(timeIndex == kMaxMargin && [phone length] > 0)
        {
            cell.codeButton.alpha = 1;
            cell.codeButton.enabled = YES;
        }
        else
        {
            cell.codeButton.alpha = kUnableAlpha;
            cell.codeButton.enabled = NO;
        }
        cell.tf.tag = kCodeFieldTag;
        cell.tf.text = code;
        [cell.codeButton setTitle:countBackString forState:UIControlStateNormal];
        [cell.codeButton addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}
- (void)dealloc
{
    [myTimer invalidate];
    myTimer = nil;
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
