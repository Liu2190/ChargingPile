//
//  CPRegisterViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPResetPasswordViewController.h"
#import "CPSetPasswordViewController.h"

#import "CPRegisterTableViewCell.h"

#import "CPLoginServer.h"
#import "BeRegularExpressionUtil.h"

#define kPhoneFieldTag 99999
#define kCodeFieldTag 88888
//最大秒数间隔
#define kMaxMargin 10
#define kUnableAlpha 0.5
@interface CPResetPasswordViewController ()<UITextFieldDelegate>
{
    NSString *phone;
    NSString *code;
    
    int timeIndex;
    NSTimer *myTimer;
    
    NSString *countBackString;
    UIButton *inquireButton;
}

@end

@implementation CPResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    timeIndex = kMaxMargin;
    countBackString = @"验证码";
    phone = [[NSString alloc]init];
    code = [[NSString alloc]init];
    self.title = self.sourceType == CPRegisterVCTypeRegister?@"注册":@"重置密码";
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, kScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"下一步" forState:UIControlStateNormal];
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
#pragma mark - 下一步
- (void)inquireAction
{
    [MBProgressHUD showMessage:@""];
    [[ServerFactory getServerInstance:@"CPLoginServer"]doCheckSMSVerificationCodeWith:phone andCode:code andSuccess:^(NSDictionary *callback)
     {
         [MBProgressHUD hideHUD];
         CPSetPasswordViewController *setVC = [[CPSetPasswordViewController alloc]init];
         setVC.sourceType = self.sourceType;
         setVC.phone = [phone mutableCopy];
         setVC.code = [code mutableCopy];
         [self.navigationController pushViewController:setVC animated:YES];
     }andFailure:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
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
    CPRegisterTableViewCell *cell = (CPRegisterTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];;
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
           if(phone.length == 11 && ![BeRegularExpressionUtil validateMobile:phone])
           {
               [MBProgressHUD showError:@"请输入正确格式的手机号码"];
           }
       }
       else if(tf.tag == kCodeFieldTag)
       {
           code = tf.text;
       }
   }
    
    CPRegisterTableViewCell *cell2 = (CPRegisterTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];;
    
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
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.codeButton.hidden = YES;
        cell.tf.tag = kPhoneFieldTag;
        cell.tf.text = phone;
        cell.tf.placeholder = @"请输入手机号";
        cell.tf.keyboardType = UIKeyboardTypePhonePad;
        cell.tf.delegate = self;
        return cell;
    }
    else{
        CPRegisterTableViewCell *cell = [CPRegisterTableViewCell cellWithTableView:tableView];
        cell.tf.width = kScreenW - 170;
        cell.tf.placeholder = @"请输入验证码";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [myTimer invalidate];
    myTimer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
