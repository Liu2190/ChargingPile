//
//  CPServiceViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/12.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPServiceViewController.h"

#define kTitleKey   @"TitleKey"
#define kContentKey @"ContentKey"

@interface CPServiceViewController ()

@end

@implementation CPServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服";
    [self setHeaderView];
    [self.dataArray addObjectsFromArray:@[@{kTitleKey:@"客服电话",kContentKey:@"010-89435711"},@{kTitleKey:@"客服QQ",kContentKey:@"3233053674"},@{kTitleKey:@"客服微信",kContentKey:@"lisa798655"}]];
    // Do any additional setup after loading the view.
}
- (void)setHeaderView
{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    UIImageView *iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myServiceIcon"]];
    iconIV.y = 48;
    iconIV.centerX = kScreenW/2.0;
    [tableHeaderView addSubview:iconIV];
    
    UIImageView *titleIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yichong_title"]];
    titleIV.y = CGRectGetMaxY(iconIV.frame) + 15;
    titleIV.centerX = kScreenW/2.0;
    [tableHeaderView addSubview:titleIV];
    
    self.tableView.tableHeaderView = tableHeaderView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row][kTitleKey];
    cell.detailTextLabel.text = self.dataArray[indexPath.row][kContentKey];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = kOrderListCellFont;
    cell.detailTextLabel.font = kOrderListCellFont;
    return cell;
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
