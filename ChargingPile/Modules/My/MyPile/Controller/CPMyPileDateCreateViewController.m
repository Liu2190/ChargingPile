//
//  CPMyPileDateCreateViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDateCreateViewController.h"
#import "CPMyPileDateCreateDatePickerView.h"

@interface CPMyPileDateCreateViewController ()
{
    NSString *beginTime,*endTime;
    NSMutableArray *weekArray;
}

@end

@implementation CPMyPileDateCreateViewController
- (id)init
{
    if(self = [super init])
    {
        self.dateModel = [[CPPileDateModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    beginTime = endTime = @"";
    beginTime = self.dateModel.beginTime;
    endTime = self.dateModel.endTime;
    weekArray = [[NSMutableArray alloc]initWithArray:[self.dateModel.days componentsSeparatedByString:@","]];
    [self checkWeekData];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.dataArray addObjectsFromArray:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}
- (void)rightAction
{
    if([beginTime length] < 1)
    {
        [MBProgressHUD showError:@"请选择开始时间"];
        return;
    }
    if([endTime length] < 1)
    {
        [MBProgressHUD showError:@"请选择结束时间"];
        return;
    }
    if([weekArray count] < 1)
    {
        [MBProgressHUD showError:@"请选择日期"];
        return;
    }
    self.dateModel.beginTime = [beginTime mutableCopy];
    self.dateModel.endTime = [endTime mutableCopy];
    self.dateModel.days = [weekArray componentsJoinedByString:@","];
    if([[self.dateModel.days substringToIndex:1]isEqualToString:@","])
    {
        self.dateModel.days = [self.dateModel.days substringFromIndex:1];
    }
    if([[self.dateModel.days substringFromIndex:[self.dateModel.days length]-1]isEqualToString:@","])
    {
        self.dateModel.days = [self.dateModel.days substringToIndex:[self.dateModel.days length]-1];
    }
    if(self.block)
    {
        self.block(self.dateModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?2:self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0.01:30.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth, headerView.height)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"请选择日期";
    [headerView addSubview:titleLabel];
    return section == 0?nil:headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = indexPath.row == 0?@"开始时间":@"结束时间";
        if(indexPath.row == 0)
        {
            cell.detailTextLabel.text = beginTime.length>0?beginTime:@"选择时间";
        }
        else
        {
            cell.detailTextLabel.text = endTime.length>0?endTime:@"选择时间";
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"";
        cell.textLabel.text = self.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(UIImageView *subview in [cell subviews])
        {
            if([subview isKindOfClass:[UIImageView class]])
            {
                [subview removeFromSuperview];
            }
        }
        if([weekArray containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]])
        {
            UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
            cellImage.centerY = 22.0f;
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
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        NSArray *hourArray = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
        NSInteger selectIndex = 0;
        if(beginTime.length > 0)
        {
            selectIndex = [hourArray indexOfObject:beginTime];
        }
        [[CPMyPileDateCreateDatePickerView sharedInstance]showPickerViewArray:(NSMutableArray *)hourArray andSelectIndex:selectIndex andBlock:^(NSInteger index)
        {
            beginTime = [hourArray objectAtIndex:index];
            if(endTime.length > 0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm"];
                if([[dateFormatter dateFromString:beginTime] compare:[dateFormatter dateFromString:endTime]] != NSOrderedAscending)
                {
                    endTime = @"";
                }
            }
            [self.tableView reloadData];
        }];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        NSMutableArray *hourArray = [NSMutableArray arrayWithArray: @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"]];
        if(beginTime.length > 0)
        {
            [hourArray removeObjectsInRange:NSMakeRange(0,[hourArray indexOfObject:beginTime] + 1)];
        }
        else
        {
            [hourArray removeObjectAtIndex:0];
        }
        NSInteger selectIndex = 0;
        if(endTime.length > 0)
        {
            selectIndex = [hourArray indexOfObject:endTime];
        }
        [[CPMyPileDateCreateDatePickerView sharedInstance]showPickerViewArray:(NSMutableArray *)hourArray andSelectIndex:selectIndex andBlock:^(NSInteger index)
         {
             endTime = [hourArray objectAtIndex:index];
             [self.tableView reloadData];
         }];
    }
    else
    {
        NSString *member = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        if([weekArray containsObject:member])
        {
            [weekArray removeObject:member];
        }
        else
        {
            [weekArray addObject:member];
        }
        [self.tableView reloadData];
    }
}
- (void)checkWeekData
{
    NSLog(@"weekArray = %@",weekArray);
    NSMutableIndexSet *set=[NSMutableIndexSet indexSet];
    for(int i = 0;i < weekArray.count; i++)
    {
        NSString *member = weekArray[i];
        if([member isEqualToString:@","] || [member isEqualToString:@" "] || [member isEqualToString:@""]|| [member length] < 1)
        {
            [set addIndex:i];
        }
    }
    [weekArray removeObjectsAtIndexes:set];
    NSLog(@"改变后weekArray = %@",weekArray);
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
