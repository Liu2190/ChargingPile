//
//  CPMyPileViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileViewController.h"
#import "CPPilePayAccountViewController.h"
#import "CPPileOrderViewController.h"
#import "CPMyPileListViewController.h"

@interface CPMyPileViewController ()

@end

@implementation CPMyPileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的电桩";
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?1:2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"电桩列表"];
        cell.textLabel.text = @"电桩列表";
        cell.textLabel.font = kOrderListCellFont;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    else if (indexPath.row == 0 && indexPath.section == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"我的订单"];
        cell.textLabel.text = @"我的收益记录";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    else if (indexPath.row == 1 && indexPath.section == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"电桩收款账号"];
        cell.textLabel.text = @"电桩收款账号";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        CPMyPileListViewController *pileListVC = [[CPMyPileListViewController alloc]init];
        [self.navigationController pushViewController:pileListVC animated:YES];
    }
    if (indexPath.row == 0 && indexPath.section == 1)
    {
        CPPileOrderViewController *pVC = [[CPPileOrderViewController alloc]init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
    if (indexPath.row == 1 && indexPath.section == 1)
    {
        CPPilePayAccountViewController *payVC = [[CPPilePayAccountViewController alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
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
