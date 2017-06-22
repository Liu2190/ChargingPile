//
//  CPMyWalletViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyWalletViewController.h"
#import "CPRechargeListViewController.h"
#import "CPRechargeViewController.h"

#import "ColorConfigure.h"
#import "CMPAccount.h"
#import "ServerAPI.h"

@interface CPMyWalletViewController ()
{
    NSString *money;
    UILabel *countLabel;
}

@end

@implementation CPMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    money = @"";
    [self getMoney];
    [self setHeaderView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMoney) name:kNotificationChargeSuccess object:nil];
    // Do any additional setup after loading the view.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = @"";
    cell.textLabel.text = @"充值记录";
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPRechargeListViewController *listVC = [[CPRechargeListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)setHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
    UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    bg1.backgroundColor = [ColorConfigure globalGreenColor];
    [headerView addSubview:bg1];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 44, 200, 30)];
    titleLabel.text = @"充电币数量（个）";
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.textColor = [UIColor whiteColor];
    [bg1 addSubview:titleLabel];
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    countLabel.text = money;
    countLabel.font = [UIFont systemFontOfSize:55];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.centerY = bg1.height - 60;
    [bg1 addSubview:countLabel];

    
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(80, bg1.height + 28, kScreenW - 160, 45);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"充值" forState:UIControlStateNormal];
    inquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:inquireButton];
    self.tableView.tableHeaderView = headerView;
}
- (void)rechargeAction
{
    CPRechargeViewController *rechargeVC = [[CPRechargeViewController alloc]init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}
- (void)getMoney
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/user/api/remainder/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(NSDictionary *responseObj)
     {
         int code = [[responseObj stringValueForKey:@"state"] intValue];
         if(code == 0)
         {
             money = [responseObj stringValueForKey:@"remainer"];
             countLabel.text = [NSString stringWithFormat:@"%.2f",[responseObj floatValueForKey:@"remainer"]];
         }
     }failure:^(NSError *error)
     {
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
