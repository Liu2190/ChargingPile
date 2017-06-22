//
//  CPPayViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPayViewController.h"
#import "CPChargeProceduceViewController.h"

#import "CPChargeServer.h"
#import "NSDictionary+Additions.h"
#import "CMPAccount.h"

@interface CPPayViewController ()
{
    NSString *selectString;
    NSString *orderId;
    int repeatCount;
}
@property (nonatomic,weak)NSTimer *resultTimer;
@end

@implementation CPPayViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self allTimerInvalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    selectString = [[NSString alloc]init];
    orderId = [[NSString alloc]init];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50, 0, 100, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePageTitle"]];
    titleView.centerX = view.width/2.0;
    titleView.centerY = view.height/2.0;
    [view addSubview:titleView];
    self.navigationItem.titleView = view;
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, kScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"启动" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
    // Do any additional setup after loading the view
    [self.dataArray addObjectsFromArray:@[@"10",@"20",@"30",@"50",@"0"]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleString = [NSString stringWithFormat:@"¥%@",[self.dataArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = (indexPath.row == self.dataArray.count - 1)?@"充满为止":titleString;
    for(UIImageView *subView in [cell subviews])
    {
        if([subView isKindOfClass:[UIImageView class]])
        {
            [subView removeFromSuperview];
        }
    }
    if ([selectString isEqualToString:[self.dataArray objectAtIndex:indexPath.row]])
    {
        UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
        cellImage.centerY = 22.0f;
        cellImage.centerX = kScreenW - 40;
        [cell addSubview:cellImage];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *titleString = [self.dataArray objectAtIndex:indexPath.row];
    selectString = [titleString mutableCopy];
    [self.tableView reloadData];
}
- (void)inquireAction
{
    if(selectString.length < 1)
    {
        return;
    }
    if(([selectString intValue] == 0 && [[CMPAccount sharedInstance].accountInfo.remainder intValue] < 1)||(([selectString intValue] > [[CMPAccount sharedInstance].accountInfo.remainder intValue])&&([selectString intValue] > 0)))
    {
        [CommonMethod showMesg:@"余额不足"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    [[ServerFactory getServerInstance:@"CPChargeServer"]doStartChargeWithPileNo:self.pileNo andMoney:selectString andSuccessCallback:^(NSDictionary *callback)
     {
         NSLog(@"启动充电成功 = %@",callback);
         int state = [[callback stringValueForKey:@"state" defaultValue:@""] intValue];

         if(state != 0)
         {
             [MBProgressHUD hideHUD];

             if(state == 1)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@""];
                 
             }
             if(state == 2)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"电桩不存在"];
                 
             }
             if(state == 3)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"余额不足"];
                 
             }
             if(state == 4)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"电桩未通过审核"];
                 
             }
             if(state == 5)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"电桩不在线"];
                 
             }
             if(state == 6)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"电桩正在充电"];
                 
             }
             if(state == 7)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"电桩故障"];
                 
             }
            // 0:成功，1:失败，2:电桩不存在,3:余额不足,4:电桩未通过审核,5:电桩不在线,6: 电桩正在充电,7:电桩故障
             return ;
         }
         orderId = [callback stringValueForKey:@"orderId" defaultValue:@""];
         repeatCount = 1;
         self.resultTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshResult) userInfo:nil repeats:YES];
     }andFailureCallback:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
         [CommonMethod showMesg:@"启动失败"];
         NSLog(@"启动充电失败 = %@",error);
     }];
}
#pragma mark - 轮询结果
- (void)refreshResult
{
    if(repeatCount > 12)
    {
        [MBProgressHUD hideHUD];
        //0:电桩未返回结果，1:启动成功，2:启动失败
        [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"电桩未返回结果"];
        [self allTimerInvalidate];
        return ;
    }
    [[ServerFactory getServerInstance:@"CPChargeServer"]doInquireStartChargeResultWithOrderId:orderId andSuccessCallback:^(NSDictionary *callback)
     {
         repeatCount ++;
         if([[callback stringValueForKey:@"result" defaultValue:@""] intValue] == 1)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"启动充电成功"];
             [self allTimerInvalidate];
             CPChargeProceduceViewController *toCharge = [[CPChargeProceduceViewController alloc]init];
             toCharge.orderId = orderId;
             [self.navigationController pushViewController:toCharge animated:YES];
             return ;
         }
         if([[callback stringValueForKey:@"result" defaultValue:@""] intValue] == 2)
         {
             /*
              1 	已经开机
              2	不是待机状态
              3	枪未连接
              4	其他
              */
             int reason = [[callback stringValueForKey:@"reason" defaultValue:@""] intValue];
             [MBProgressHUD hideHUD];
             if(reason == 1)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"已经开机"];

             }
             else if (reason == 2)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"不是待机状态"];

             }
             else if (reason == 3)
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"枪未连接"];

             }
             else
             {
                 [CommonMethod showMesgWithTitle:@"启动充电失败" andMsg:@"其他"];
             }
             
             [self allTimerInvalidate];
             return ;
         }
     }andFailureCallback:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
         [CommonMethod showMesg:@"启动失败"];
         [self allTimerInvalidate];
         NSLog(@"启动充电失败 = %@",error);
     }];
}
- (void)allTimerInvalidate
{
    [self.resultTimer invalidate];
    self.resultTimer = nil;
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
