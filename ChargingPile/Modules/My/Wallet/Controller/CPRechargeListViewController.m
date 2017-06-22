//
//  CPRechargeListViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPRechargeListViewController.h"
#import "CPChargeListModel.h"
#import "CMPAccount.h"
#import "ServerAPI.h"
#import "ColorConfigure.h"
#import "MJRefresh.h"

@interface CPRechargeListViewController ()
{
    int pageNum,pageCount;
}

@end

@implementation CPRechargeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值记录";
    pageNum = 1;
    pageNum = pageCount = 1,
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
    [self refreshAction];
    // Do any additional setup after loading the view.
}
- (void)refreshAction
{
    pageNum = 1;
    [self getDataWith:pageNum];
}
- (void)addMoreAction
{
    if(pageNum < pageCount)
    {
        pageNum ++;
        [self getDataWith:pageNum];
    }
    else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    CPChargeListModel *listModel = self.dataArray[indexPath.section];
    if(indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"chargeOrderList1"];
        cell.textLabel.text = @"充值金额";
        cell.textLabel.font = kOrderListCellFont;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",listModel.amount];
        cell.detailTextLabel.textColor = [ColorConfigure globalGreenColor];
        cell.detailTextLabel.font = kOrderListCellFont;
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"chargeOrderList2"];
        cell.textLabel.text = @"充值时间";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.text = listModel.chargeDisplayTime;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = kOrderListCellFont;
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"chargeOrderList3"];
        cell.textLabel.text = @"充值方式";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.text = [listModel.payBy intValue] == 0?@"支付宝支付":@"微信支付";
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = kOrderListCellFont;
    }
    return cell;
}
- (void)getDataWith:(int)currentPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/recharge/api/record/%@?page=%d",kServerHost,[CMPAccount sharedInstance].accountInfo.uid,currentPage];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             pageCount = [[responseObj objectForKey:@"count"] intValue];
             if(currentPage == 1)
             {
                 [self.dataArray removeAllObjects];
             }
             for(NSDictionary *member in [responseObj objectForKey:@"list"])
             {
                 CPChargeListModel *listModel = [[CPChargeListModel alloc]initWith:member];
                 [self.dataArray addObject:listModel];
             }
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshing];
             [self.tableView.mj_header endRefreshing];
         }
     }failure:^(NSError *error)
     {
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_header endRefreshing];
     }];
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
