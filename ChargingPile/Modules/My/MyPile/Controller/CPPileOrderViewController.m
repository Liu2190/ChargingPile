//
//  CPPileOrderViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileOrderViewController.h"

#import "CPOrderListTableViewCell.h"
#import "CPMyPileOrderHeaderView.h"
#import "CPPileOrderFooterView.h"

#import "CPOrderServer.h"
#import "CMPAccount.h"
#import "ServerAPI.h"
#import "MJRefresh.h"

@interface CPPileOrderViewController ()
{
    int pageNum,pageCount;
    CPMyPileOrderHeaderView *headerView;
    OrderListModelType selectType;
    CPPileOrderFooterView *footerView;
}

@end

@implementation CPPileOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收益记录";
    selectType = OrderListModelTypePileOwnerWJS;
    pageNum = pageCount = 1,
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
    [self refreshAction];
    headerView = [[CPMyPileOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kCPMyPileOrderHeaderViewHeight)];
    headerView.type = selectType;
    [headerView addTarget:self andWJS:@selector(typeChangedAction:) andYJS:@selector(typeChangedAction:)];
    [self.view addSubview:headerView];
    
    footerView = [[CPPileOrderFooterView alloc]initWithFrame:CGRectMake(0, kScreenH - headerView.height - 64.0, kScreenW, kCPPileOrderFooterViewHeight)];
    [self.view addSubview:footerView];
    
    self.tableView.y = headerView.height;
    self.tableView.height = self.tableView.height - headerView.height - footerView.height;
    // Do any additional setup after loading the view.
}
- (void)typeChangedAction:(NSNumber *)typeNumer
{
    selectType = (OrderListModelType )[typeNumer integerValue];
    [self refreshAction];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/order/api/o/%@/%d?page=%d",kServerHost,[CMPAccount sharedInstance].accountInfo.uid,(int)selectType -1,currentPage];
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
                 listModel.type = selectType;
                 CPOrderListFrame *listFrame = [[CPOrderListFrame alloc]init];
                 listFrame.listModel = listModel;
                 [self.dataArray addObject:listFrame];
             }
             [self.tableView reloadData];
             [self setTotalAmount];
             [self.tableView.mj_footer endRefreshing];
             [self.tableView.mj_header endRefreshing];
         }
     }failure:^(NSError *error)
     {
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_header endRefreshing];
     }];
}
- (void)setTotalAmount
{
    for(int i = 0;i < self.dataArray.count;i++)
    {
        CPOrderListModel *listModel = self.dataArray[i];
        
    }
    //_amount = [NSString stringWithFormat:@"￥%@",[dict stringValueForKey:@"amount" defaultValue:@"0.0"]];
    //_qty = [NSString stringWithFormat:@"%@kwh",[dict stringValueForKey:@"qty"]];
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
