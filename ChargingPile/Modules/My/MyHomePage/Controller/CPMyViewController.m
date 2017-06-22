//
//  CPMyViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyViewController.h"
#import "CPSettingViewController.h"
#import "CPHelpFeedBackViewController.h"
#import "CPAccountViewController.h"
#import "CPServiceViewController.h"
#import "CPMyOrderListViewController.h"
#import "CPMyWalletViewController.h"
#import "CPLoginViewController.h"
#import "CPNavigationController.h"
#import "CPCollectionViewController.h"
#import "CPPileEvalutionListViewController.h"
#import "CPMyPileViewController.h"

#import "CPMyAccountView.h"
#import "ServerAPI.h"

#import "CPLoginServer.h"
#import "BeRegularExpressionUtil.h"
#import "CMPAccount.h"
#import "NSDictionary+Additions.h"
#import "SDImageCache.h"
#import "CPAccountUtility.h"

#define kTitle @"cellTitle"
#define kImage @"cellImage"

@interface CPMyViewController ()
{
    CPMyAccountView *headerView;
}

@end

@implementation CPMyViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAction) name:kNotificationLogOffSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo) name:kNotificationUploadHeaderSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMyView) name:kNotificationUpdateUserInfoSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo) name:kNotificationLoginSuccess object:nil];
    self.title = @"我的";
    [self.dataArray addObject:@[@{kTitle:@"我的消费记录",kImage:@"我的订单"},@{kTitle:@"我的钱包",kImage:@"我的钱包"}]];
    [self.dataArray addObject:@[@{kTitle:@"我的收藏",kImage:@"我的收藏"},@{kTitle:@"我的评价",kImage:@"我的评价"},@{kTitle:@"我的电桩",kImage:@"我的电桩"}]];
    [self.dataArray addObject:@[@{kTitle:@"帮助与反馈",kImage:@"帮助与反馈"},@{kTitle:@"设置",kImage:@"我的设置"}]];
    
    headerView = [[CPMyAccountView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kCPMyAccountViewHeight)];
    
    [self getUserInfo];
    for(UIView *subview in [headerView subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    [self.tableView addSubview:headerView];
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kCPMyAccountViewHeight)];
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookupAccount)];
    [self.tableView.tableHeaderView addGestureRecognizer:tap];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self animationForTableView];
}
- (void)animationForTableView{
    CGFloat offset = self.tableView.contentOffset.y;
    if (self.tableView.contentOffset.y < 0) {
        headerView.frame = CGRectMake(0,offset, kScreenW, kCPMyAccountViewHeight + (-offset));
    }
    [headerView changeSubviewsFrame];
}
- (void)rightAction
{
    CPServiceViewController *serVC = [[CPServiceViewController alloc]init];
    [self.navigationController pushViewController:serVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *imageName = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kImage];
    NSString *title = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kTitle];
    cell.textLabel.text = title;
    cell.textLabel.font = kOrderListCellFont;
    cell.detailTextLabel.font = kOrderListCellFont;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSString *title = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kTitle];
    if([title isEqualToString:@"设置"])
    {
        CPSettingViewController *settingVC = [[CPSettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    else if ([title isEqualToString:@"帮助与反馈"])
    {
        CPHelpFeedBackViewController *feedVC = [[CPHelpFeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedVC animated:YES];
    }
    else if ([title isEqualToString:@"我的消费记录"])
    {
        CPMyOrderListViewController *orderVC = [[CPMyOrderListViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else if ([title isEqualToString:@"我的钱包"])
    {
        CPMyWalletViewController *waVC = [[CPMyWalletViewController alloc]init];
        [self.navigationController pushViewController:waVC animated:YES];
    }
    else if ([title isEqualToString:@"我的收藏"])
    {
        CPCollectionViewController *coVC = [[CPCollectionViewController alloc]init];
        [self.navigationController pushViewController:coVC animated:YES];
    }
    else if ([title isEqualToString:@"我的评价"])
    {
        CPPileEvalutionListViewController *eVC = [[CPPileEvalutionListViewController alloc]init];
        eVC.sourceType = CPPileEvalutionModelTypeMy;
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if ([title isEqualToString:@"我的电桩"])
    {
        CPMyPileViewController *pileVC = [[CPMyPileViewController alloc]init];
        [self.navigationController pushViewController:pileVC animated:YES];
    }
}
#pragma mark - 查看个人信息页面
- (void)lookupAccount
{
    CPAccountViewController *accountVC = [[CPAccountViewController alloc]init];
    [self.navigationController pushViewController:accountVC animated:YES];
}
- (void)getUserInfo
{
    headerView.accountNameLabel.text = [CMPAccount sharedInstance].accountInfo.name;
    [headerView.accountImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid]] placeholderImage:[UIImage imageNamed:@"woItem"]];
}
- (void)reloadMyView
{
    headerView.accountNameLabel.text = [CMPAccount sharedInstance].accountInfo.name;
}
- (void)loginAction
{
    [[CMPAccount sharedInstance].accountInfo clearData];
    CPLoginViewController *loginVC = [[CPLoginViewController alloc]init];
    CPNavigationController *nav = [[CPNavigationController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:
     YES completion:nil];
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
