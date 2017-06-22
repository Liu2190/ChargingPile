//
//  CPEditInfoViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPEditInfoViewController.h"
#import "CMPAccount.h"
#import "CPAccountUtility.h"
#import "BeRegularExpressionUtil.h"

@interface CPEditInfoViewController ()
{
    NSArray *genderArray;
    NSString *selectString;
}

@end

@implementation CPEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArray = @[@"姓名",@"性别",@"身份证号码",@"QQ",@"地址"];
    self.title = titleArray[self.sourceType];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
    genderArray = @[@"男",@"女"];
    if(self.sourceType == EditInfoVCSourceTypeName)
    {
        selectString = [CMPAccount sharedInstance].accountInfo.name;
    }
    else if(self.sourceType == EditInfoVCSourceTypeGender)
    {
        selectString = [[CMPAccount sharedInstance].accountInfo.gender isEqualToString:@"m"]?@"男":@"女";
    }
    else if(self.sourceType == EditInfoVCSourceTypeIdCard)
    {
        selectString = [CMPAccount sharedInstance].accountInfo.idNo;
    }
    else if(self.sourceType == EditInfoVCSourceTypeQQ)
    {
        selectString = [CMPAccount sharedInstance].accountInfo.qq;
    }
    else if(self.sourceType == EditInfoVCSourceTypeAddress)
    {
        selectString = [CMPAccount sharedInstance].accountInfo.address;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.sourceType == EditInfoVCSourceTypeName? 20.0f:0.0f;;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    view.backgroundColor = [ColorUtility colorFromHex:0xf8f8f8];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20.0f)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0 ,kScreenW - 30,20)];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"设置后，其他人将看到您的姓名";
    [view addSubview:contentLabel];
    return self.sourceType == EditInfoVCSourceTypeName? view:nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceType == EditInfoVCSourceTypeGender? 2:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(self.sourceType == EditInfoVCSourceTypeGender)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = genderArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        for(UIImageView *subView in [cell subviews])
        {
            if([subView isKindOfClass:[UIImageView class]])
            {
                [subView removeFromSuperview];
            }
        }
        if ([selectString isEqualToString:cell.textLabel.text])
        {
            UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
            cellImage.centerY = 22.0f;
            cellImage.centerX = kScreenW - 40;
            [cell addSubview:cellImage];
        }
    }
    else
    {
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
        infoTextField.text = selectString;
        infoTextField.placeholder = [NSString stringWithFormat:@"请输入您的%@",self.title];
        [cell addSubview:infoTextField];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.sourceType == EditInfoVCSourceTypeGender)
    {
        selectString = [genderArray[indexPath.row] mutableCopy];
        [self.tableView reloadData];
    }
}
- (void)rightAction
{
    /*
     if(self.sourceType == EditInfoVCSourceTypeName)
     {
     selectString = [CMPAccount sharedInstance].accountInfo.name;
     }
     else if(self.sourceType == EditInfoVCSourceTypeGender)
     {
     selectString = [[CMPAccount sharedInstance].accountInfo.gender isEqualToString:@"m"]?@"男":@"女";
     }
     else if(self.sourceType == EditInfoVCSourceTypeIdCard)
     {
     selectString = [CMPAccount sharedInstance].accountInfo.idNo;
     }
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //@{@"id":@"17",@"gender":@"f",@"idNo":@"123"};
    switch (self.sourceType) {
        case EditInfoVCSourceTypeName:
        {
            if(selectString.length < 1)
            {
                [MBProgressHUD showError:@"请输入姓名"];
                return;
            }
            if(selectString.length > 20)
            {
                [MBProgressHUD showError:@"姓名过长，请重新输入"];
                return;
            }
            if([selectString isEqualToString:[CMPAccount sharedInstance].accountInfo.name])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            params[@"name"] = selectString;
        }
            break;
        case EditInfoVCSourceTypeGender:
        {
            if(selectString.length < 1)
            {
                [MBProgressHUD showError:@"请选择性别"];
                return;
            }
            NSString *gender = [selectString isEqualToString:@"男"]?@"m":@"f";
            if([gender isEqualToString:[CMPAccount sharedInstance].accountInfo.gender])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            params[@"gender"] = gender;
        }
            break;
        case EditInfoVCSourceTypeIdCard:
        {
            if(selectString.length < 1)
            {
                [MBProgressHUD showError:@"请输入身份证号"];
                return;
            }
            if([selectString isEqualToString:[CMPAccount sharedInstance].accountInfo.idNo])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if(![BeRegularExpressionUtil validateIdentityCard:selectString])
            {
                [MBProgressHUD showError:@"请输入正确格式的身份证号"];
                return;
            }
            params[@"idNo"] = selectString;
        }
            break;
        case EditInfoVCSourceTypeQQ:
        {
            if(selectString.length < 1)
            {
                [MBProgressHUD showError:@"请输入QQ号码"];
                return;
            }
            if([selectString isEqualToString:[CMPAccount sharedInstance].accountInfo.qq])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            params[@"qq"] = selectString;
        }
            break;
        case EditInfoVCSourceTypeAddress:
        {
            if(selectString.length < 1)
            {
                [MBProgressHUD showError:@"请输入地址"];
                return;
            }
            if([selectString isEqualToString:[CMPAccount sharedInstance].accountInfo.address])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            params[@"address"] = selectString;
        }
            break;
        default:
            break;
    }
    [MBProgressHUD showMessage:@""];
    [[CPAccountUtility getSharedInstance]updateUserInfoWith:params andSuccessCallback:^(NSString *successCallback)
     {
         [MBProgressHUD hideHUD];
         if(self.sourceType == EditInfoVCSourceTypeName)
         {
            [CMPAccount sharedInstance].accountInfo.name = [selectString mutableCopy];
         }
         else if(self.sourceType == EditInfoVCSourceTypeGender)
         {
            [CMPAccount sharedInstance].accountInfo.gender = [ selectString isEqualToString:@"男"]?@"m":@"f";
         }
         else if(self.sourceType == EditInfoVCSourceTypeIdCard)
         {
            [CMPAccount sharedInstance].accountInfo.idNo = [selectString mutableCopy];
         }
         else if(self.sourceType == EditInfoVCSourceTypeQQ)
         {
             [CMPAccount sharedInstance].accountInfo.qq = [selectString mutableCopy];
         }
         else if(self.sourceType == EditInfoVCSourceTypeAddress)
         {
             [CMPAccount sharedInstance].accountInfo.address = [selectString mutableCopy];
         }
         [MBProgressHUD showSuccess:successCallback];
         [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUpdateUserInfoSuccess object:nil];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
         });
     }andFailureCallback:^(NSString *failureCallback)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:failureCallback];
     }];
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = (UITextField *)noti.object;
    selectString = tf.text;
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
