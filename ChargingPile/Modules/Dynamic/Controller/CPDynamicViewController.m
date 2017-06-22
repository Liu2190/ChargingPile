//
//  CPDynamicViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicViewController.h"
#import "CPDynamicDetailViewController.h"

#import "CPDynamicBannerTableViewCell.h"
#import "CPDynamicListTableViewCell.h"

#import "MJRefresh.h"
#import "CMPAccount.h"
#import "ServerAPI.h"
#import "CPDynamicListModel.h"
#import "UIImageView+WebCache.h"

@interface CPDynamicViewController ()<HomeBannerDelegate>
{
    int pageNum,pageCount;
    NSMutableArray *banners;
}
@end

@implementation CPDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNum = pageCount = 1;
    banners = [[NSMutableArray alloc]init];
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
- (void)getDataWith:(int)currentPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/news/api/list",kServerHost];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:@{@"page":[NSNumber numberWithInt:currentPage]} success:^(id responseObj)
     {
         NSLog(@"动态 = %@",responseObj);
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             pageCount = [responseObj intValueForKey:@"count"defaultValue:1];
             if(currentPage == 1)
             {
                 [self.dataArray removeAllObjects];
             }
             [banners removeAllObjects];
             for(NSString *member in [responseObj objectForKey:@"banners"])
             {
                 [banners addObject:@{@"img":[NSString stringWithFormat:@"%@rest/news/api/image/%@",kServerHost,member],@"url":member}];
             }
             for(NSDictionary *member in [responseObj objectForKey:@"list"])
             {
                 CPDynamicListModel *model = [[CPDynamicListModel alloc]initWith:member];
                 [self.dataArray addObject:model];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?1:self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0?kBannerHeight:kDynamicListHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0.001: 20.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth, 20)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"动态关注";
    [headerView addSubview:titleLabel];
    return section == 0?nil:headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        CPDynamicBannerTableViewCell *cell = [CPDynamicBannerTableViewCell cellWithTableView:tableView];
        cell.imagesArray = banners;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        CPDynamicListTableViewCell *cell = [CPDynamicListTableViewCell cellWithTableView:tableView];
        CPDynamicListModel *model = self.dataArray[indexPath.row];
        cell.listTitleLabel.text = model.title;
        cell.listContentLabel.text = model.subTitle;
        cell.listtimeLabel.text = model.createTime;
        CPDynamicListModel *listModel = self.dataArray[indexPath.row];
        [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/news/api/thumb/%@",kServerHost,listModel.dynamicId]]];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        CPDynamicListModel *model = self.dataArray[indexPath.row];
        CPDynamicDetailViewController *detailVC = [[CPDynamicDetailViewController alloc]init];
        detailVC.dynamicId = [model.dynamicId mutableCopy];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)homeBannerViewDidClick:(NSString *)webViewUrl
{
    CPDynamicDetailViewController *detailVC = [[CPDynamicDetailViewController alloc]init];
    detailVC.dynamicId = webViewUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
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
