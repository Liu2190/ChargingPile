//
//  CPMyPileListViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileListViewController.h"
#import "CPMyPileDetailViewController.h"

#import "CPMyPileListTableViewCell.h"
#import "CPMyPileListModel.h"

#import "CMPAccount.h"
#import "ServerAPI.h"
#import "MJRefresh.h"

@interface CPMyPileListViewController ()
{
    int pageNum,pageCount;
}
@end

@implementation CPMyPileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电桩列表";
    pageNum = pageCount = 1,
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
    [self refreshAction];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.tableView.separatorColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCPMyPileListTableViewCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMyPileListTableViewCell *cell = [CPMyPileListTableViewCell cellWithTableView:tableView];
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMyPileDetailViewController *detailVC = [[CPMyPileDetailViewController alloc]init];
    CPMyPileListModel *listModel = self.dataArray[indexPath.row];
    detailVC.pileId = [listModel.pileId mutableCopy];
    detailVC.sourceType = CPMyPileDetailVCSourceTypeEdit;
    [self.navigationController pushViewController:detailVC animated:YES];
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
- (void)getDataWith:(int)currentPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/pile/api/u/%@?page=%d",kServerHost,[CMPAccount sharedInstance].accountInfo.uid,currentPage];
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
                 CPMyPileListModel *listModel = [[CPMyPileListModel alloc]initWith:member];
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
- (void)rightAction
{
    CPMyPileDetailViewController *detailVC = [[CPMyPileDetailViewController alloc]init];
    detailVC.sourceType = CPMyPileDetailVCSourceTypeCreate;
    detailVC.block = ^
    {
        [self refreshAction];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
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
    // Pas  s the selected object to the new view controller.
}
*/

@end
