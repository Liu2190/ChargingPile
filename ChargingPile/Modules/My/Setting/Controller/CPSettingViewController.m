//
//  CPSettingViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPSettingViewController.h"
#import "BeFileHandle.h"

@interface CPSettingViewController ()

@end

@implementation CPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = @"清除缓存";
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    float imageSize = ([[BeFileHandle sharedInstance]cacheSize]/1024.0/1024.0);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",imageSize];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[BeFileHandle sharedInstance]clearCache];
    [MBProgressHUD showSuccess:@"清除缓存成功"];
    NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationNone];
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
