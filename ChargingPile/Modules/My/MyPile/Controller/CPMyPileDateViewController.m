//
//  CPMyPileDateViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDateViewController.h"
#import "CPMyPileDateCreateViewController.h"

#import "CPMyPileDateTableViewCell.h"
#import "CMPAccount.h"
#import "ServerAPI.h"

@interface CPMyPileDateViewController ()

@end

@implementation CPMyPileDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"时间选择";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self getTimeData];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0?kCPMyPileDateTableViewCell1Height :kCPMyPileDateTableViewCell2Height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CPMyPileDateTitleTableViewCell *cell =[CPMyPileDateTitleTableViewCell cellWithTableView:tableView];
        cell.dateTitleLabel.text = [NSString stringWithFormat:@"时间段%d",(int)indexPath.section + 1];
        return cell;
    }
    else
    {
        CPMyPileDateContentTableViewCell *cell =[CPMyPileDateContentTableViewCell cellWithTableView:tableView];
        CPPileDateModel *model = self.dataArray[indexPath.section];
        cell.dateModel = model;
        for(UIImageView *subview in [cell subviews])
        {
            if([subview isKindOfClass:[UIImageView class]])
            {
                [subview removeFromSuperview];
            }
        }
        if(model.selected)
        {
            UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
            cellImage.centerY = kCPMyPileDateTableViewCell2Height/2.0;
            cellImage.centerX = kScreenW - 40;
            [cell addSubview:cellImage];
        }
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPPileDateModel *model = self.dataArray[indexPath.section];
    if(indexPath.row == 0)
    {
        CPMyPileDateCreateViewController *createVC = [[CPMyPileDateCreateViewController alloc]init];
        createVC.dateModel = model;
        createVC.block = ^(CPPileDateModel *editModel){
            [self editDateModelWith:editModel];
        };
        [self.navigationController pushViewController:createVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        if(model.days.length < 1)
        {
            [MBProgressHUD showError:@"请选择日期"];
            return;
        }
        if(model.beginTime.length < 1)
        {
            [MBProgressHUD showError:@"请选择开始时间"];
            return;
        }
        if(model.endTime.length < 1)
        {
            [MBProgressHUD showError:@"请选择结束时间"];
            return;
        }
        for(CPPileDateModel *member in self.dataArray)
        {
            if([self.dataArray indexOfObject:member] == indexPath.section)
            {
                member.selected = !member.selected;
            }
            else
            {
                member.selected = NO;
            }
        }
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.block && model.selected)
            {
                self.block(model);
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }
}
- (void)rightAction
{
    CPMyPileDateCreateViewController *createVC = [[CPMyPileDateCreateViewController alloc]init];
    createVC.block = ^(CPPileDateModel *editModel){
        [self editDateModelWith:editModel];
    };
    [self.navigationController pushViewController:createVC animated:YES];
}
- (void)getTimeData
{
    [MBProgressHUD showMessage:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/pile/api/time/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         [MBProgressHUD hideHUD];
         NSLog(@"电桩时间段=%@",responseObj);
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             [self.dataArray removeAllObjects];
             for(NSDictionary *member in [responseObj objectForKey:@"list"])
             {
                 CPPileDateModel *listModel = [[CPPileDateModel alloc]init];
                 [listModel setDataWithDict:member];
                 if([listModel.days isEqualToString:self.selectModel.days] && [listModel.beginTime isEqualToString:self.selectModel.beginTime] && [listModel.endTime isEqualToString:self.selectModel.endTime])
                 {
                     listModel.selected = YES;
                 }
                 [self.dataArray addObject:listModel];
             }
             [self.tableView reloadData];
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}
- (void)editDateModelWith:(CPPileDateModel *)model
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/pile/api/time",kServerHost];
    /*
     id	时间段id,新添加可以不传,修改的时候必填
     userId	用户id
     days	周日到周六分别为1,2,3,4,5,6,7，中间用英文逗号分隔
     beginTime	开始时间
     endTime	结束时间
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(model.dateId.length > 0)
    {
        params[@"id"] = model.dateId;
    }
    params[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"days"] = model.days;
    params[@"beginTime"] = model.beginTime;
    params[@"endTime"] = model.endTime;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         NSLog(@"修改电桩时间=%@",responseObj);
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             [self getTimeData];
         }
     }failure:^(NSError *error)
     {
         
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
