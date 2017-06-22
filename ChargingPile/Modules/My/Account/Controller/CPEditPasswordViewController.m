//
//  CPEditPasswordViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPEditPasswordViewController.h"
#import "CMPAccount.h"
#import "BeRegularExpressionUtil.h"
#import "NSString+sha256.h"
#import "ServerAPI.h"
#import "NSDictionary+Additions.h"

#define kPasswordTip @"密码只支持数字，字母及下划线，6-16个字符"
#define kPlaceHolder1 @"请输入当前密码"
#define kPlaceHolder2 @"请输入新密码"
#define kPlaceHolder3 @"确认新密码"
@interface CPEditPasswordViewController ()
{
    NSString *password1,*password2,*password3;
}

@end

@implementation CPEditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更改密码";
    password1 = password2 = password3 = @"";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
    [self.dataArray addObjectsFromArray:@[kPlaceHolder1,kPlaceHolder2,kPlaceHolder3]];
    [self setFooterView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44.0f)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 ,kScreenW - 30,20)];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = kPasswordTip;
    [view addSubview:contentLabel];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for(UITextField *subView in [cell subviews])
    {
        if([subView isKindOfClass:[UITextField class]])
        {
            [subView removeFromSuperview];
        }
    }
    UITextField *infoTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW - 30, 44)];
    infoTextField.textColor = [UIColor darkGrayColor];
    infoTextField.font = [UIFont systemFontOfSize:14];
    infoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    infoTextField.secureTextEntry = YES;
    infoTextField.placeholder = self.dataArray[indexPath.row];
    infoTextField.tag = indexPath.row;
    if(indexPath.row == 0)
    {
        infoTextField.text = password1;
    }
    else if (indexPath.row == 1)
    {
        infoTextField.text = password2;
    }
    else if (indexPath.row == 2)
    {
        infoTextField.text = password3;
    }
    [cell addSubview:infoTextField];
    return cell;
}

- (void)setFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, kScreenW - 30, 45);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"确定" forState:UIControlStateNormal];
    inquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}
- (void)sureAction
{
    if(password1.length < 1)
    {
        [MBProgressHUD showError:kPlaceHolder1];
        return;
    }
    if(password2.length < 1)
    {
        [MBProgressHUD showError:kPlaceHolder2];
        return;
    }
    if(password3.length < 1)
    {
        [MBProgressHUD showError:kPlaceHolder2];
        return;
    }
    if(![password2 isEqualToString:password3])
    {
        [MBProgressHUD showError:@"新密码输入不一致"];
        return;
    }
    /*
     修改密码 (rest/user/api/updatePwd)
     
     id	用户id
     password	密码(PBKDF2加密后的密文)
     opassword	旧密码(PBKDF2加密后的密文)
     
     state	0:成功 1:失败 2:旧密码不正确
     */
    [MBProgressHUD showMessage:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/updatePwd"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"id"] = [CMPAccount sharedInstance].accountInfo.uid;
    parameter[@"password"] = [password2 sha256];
    parameter[@"opassword"] = [password1 sha256];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(NSDictionary *responseObj)
     {
         [MBProgressHUD hideHUD];
         int code = [[responseObj stringValueForKey:@"state"] intValue];
         if(code == 0)
         {
             [MBProgressHUD showSuccess:@"修改成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }
         else if (code == 1)
         {
             [MBProgressHUD showError:@"修改失败"];
         }
         else if (code == 2)
         {
             [MBProgressHUD showError:@"旧密码不正确"];
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"修改失败"];
     }];
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = (UITextField *)noti.object;
    switch (tf.tag) {
        case 0:
            password1 = tf.text;
            break;
        case 1:
            password2 = tf.text;
            break;
        case 2:
            password3 = tf.text;
            break;
        default:
            password1 = tf.text;
            break;
    }
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
