//
//  CPCollectionViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPCollectionViewController.h"
#import "CPPileDetailViewController.h"

#import "CPPileListHeaderView.h"
#import "CPFindPileListTableViewCell.h"
#import "CPPileAnnotationView.h"
#import "CPFindPileFooterView.h"
#import "CPFindPileConditionView.h"

#import "CPPileAnnotation.h"
#import "CPPlieModel.h"
#import "ServerAPI.h"

#import "MapCommonUtility.h"
#import "CPFindPileServer.h"
#import "CMPAccount.h"
#import "NSDictionary+Additions.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

@interface CPCollectionViewController ()
{
    int pageNum,pageCount;
}
@end

@implementation CPCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
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
#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kCPFindPileListTableViewCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPFindPileListTableViewCell *cell = [CPFindPileListTableViewCell cellWithTableView:tableView];
    cell.listModel = self.dataArray[indexPath.row];
    cell.navButton.tag = indexPath.row;
    [cell.navButton addTarget:self action:@selector(navigationAciton:) forControlEvents:UIControlEventTouchUpInside];
    cell.collectButton.tag = 1000 + indexPath.row;
    [cell.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.publicStationButton.tag = 2000 + indexPath.row;
    [cell.publicStationButton addTarget:self action:@selector(publicStationAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.priceBg.hidden = cell.priceLabel.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPPileDetailViewController *detailVC = [[CPPileDetailViewController alloc]init];
    detailVC.pileModel = self.dataArray[indexPath.row];
    detailVC.sourceType = CPPileDetailVCTypeFavor;
    detailVC.currentLocation = [AppDelegate appdelegate].coordinate;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)getDataWith:(int)currentPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/station/api/favorites/%@?page=%d",kServerHost,[CMPAccount sharedInstance].accountInfo.uid,currentPage];
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
                 if(!(member != nil && [member isKindOfClass:[NSDictionary class]]))
                 {
                     continue;
                 }
                 CPPlieModel *listModel = [[CPPlieModel alloc]initWithDict:member];
                 [listModel getDistanceWithLocation:[AppDelegate appdelegate].coordinate];
                 listModel.isFavor = YES;
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
- (void)navigationAciton:(UIButton *)sender
{
    CPPlieModel *listModel = self.dataArray[sender.tag];
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([listModel.lat doubleValue], [listModel.lng doubleValue]);
    [[MapCommonUtility sharedInstance]showNavigationSheetWithCurrentLocation:[AppDelegate appdelegate].coordinate andDestinationLocaiton:destination andDestinationTitle:listModel.name];
}
- (void)publicStationAction:(UIButton *)sender
{
    [self tableView:self.tableView didSelectRowAtIndexPath:    [NSIndexPath indexPathForRow:sender.tag - 2000 inSection:0]];
}
- (void)collectAction:(UIButton *)sender
{
    [MBProgressHUD showMessage:@""];
    CPPlieModel *listModel = self.dataArray[sender.tag - 1000];
    if(listModel.isFavor)
    {
        //取消收藏
        [[ServerFactory getServerInstance:@"CPFindPileServer"]doRemoveFavorWithStationId:listModel.pileId andSuccessCallback:^(NSDictionary *callback)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"取消收藏 = %@",callback);
             if([[callback objectForKey:@"state"] intValue] == 0)
             {
                 listModel.isFavor = !listModel.isFavor;
                 [self.dataArray removeObjectAtIndex:(sender.tag - 1000)];
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD showError:@"取消收藏失败"];
             }
         }andFailureCallback:^(NSString *error)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"获取失败 = %@",error);
             [MBProgressHUD showError:@"取消收藏失败"];
         }];
    }
    else
    {
        //添加收藏
        [[ServerFactory getServerInstance:@"CPFindPileServer"]doAddFavorWithStationId:listModel.pileId andSuccessCallback:^(NSDictionary *callback)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"添加收藏 = %@",callback);
             if([[callback objectForKey:@"state"] intValue] == 0)
             {
                 listModel.isFavor = !listModel.isFavor;
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD showError:@"添加收藏失败"];
             }
         }andFailureCallback:^(NSString *error)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"获取失败 = %@",error);
             [MBProgressHUD showError:@"添加收藏失败"];
         }];
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
