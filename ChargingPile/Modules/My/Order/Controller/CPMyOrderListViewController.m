//
//  CPMyOrderListViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/12.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyOrderListViewController.h"

#import "CPOrderListTableViewCell.h"
#import "CPOrderServer.h"
#import "CMPAccount.h"
#import "ServerAPI.h"
#import "MJRefresh.h"

@interface CPMyOrderListViewController ()
{
    int pageNum,pageCount;
}

@end

@implementation CPMyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消费记录";
    pageNum = pageCount = 1,
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
    self.tableView.separatorColor = [UIColor clearColor];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPOrderListFrame *listFrame = self.dataArray[indexPath.row];
    return listFrame.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPOrderListTableViewCell *cell = [CPOrderListTableViewCell cellWithTableView:tableView];
    cell.listFrame = self.dataArray[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getDataWith:(int)currentPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/u/%@?page=%d",kServerHost,[CMPAccount sharedInstance].accountInfo.uid,currentPage];
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
                 CPOrderListModel *listModel = [[CPOrderListModel alloc]initWith:member];
                 listModel.type = OrderListModelTypeUser;
                 CPOrderListFrame *listFrame = [[CPOrderListFrame alloc]init];
                 listFrame.listModel = listModel;
                 [self.dataArray addObject:listFrame];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
