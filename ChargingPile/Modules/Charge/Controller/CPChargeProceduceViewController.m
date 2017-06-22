//
//  CPChargeProcedureViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeProceduceViewController.h"
#import "CPChargeResultViewController.h"
#import "CPNavigationController.h"

#import "CPChargeBatteryTableViewCell.h"
#import "CPChargeProduceTableViewCell.h"
#import "CPChargeInfoTableViewCell.h"

#import "CPChargeServer.h"
#import "NSDictionary+Additions.h"
#import "CPChargeProduceModel.h"

#import "AppDelegate.h"

@interface CPChargeProceduceViewController ()
{
    NSTimer *refreshTimer;
    int secondCount;
    CPChargeProduceModel *produceModel;
    int repeatCount;
    BOOL isStop;
}
@property (nonatomic,weak)NSTimer *resultTimer;
@end

@implementation CPChargeProceduceViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self allTimerInvalidate];
    [refreshTimer invalidate];
    refreshTimer = nil;
    CPNavigationController *nav = (CPNavigationController *)self.navigationController;
    nav.canDragBack = YES;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CPNavigationController *nav = (CPNavigationController *)self.navigationController;
    nav.canDragBack = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCell) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)refreshCell
{
    NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isStop = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [[NSUserDefaults standardUserDefaults]setObject:self.orderId forKey:kLatestChargeOrderId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    produceModel = [[CPChargeProduceModel alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    [inquireButton setTitle:@"停止" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshOrderInfo) userInfo:nil repeats:YES];
    [self refreshOrderInfo];
}
#pragma mark - 停止
- (void)inquireAction
{
    isStop = YES;
    NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationNone];
    [MBProgressHUD showMessage:@""];
    [[ServerFactory getServerInstance:@"CPChargeServer"]doStopWithOrderId:self.orderId andSuccessCallback:^(NSDictionary *callback)
     {
         if([[callback objectForKey:@"state" ] intValue] != 0)
         {
             [MBProgressHUD hideHUD];
             [self allTimerInvalidate];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLatestChargeOrderId];
             CPChargeResultViewController *resultVC = [[CPChargeResultViewController alloc]init];
             resultVC.orderId = self.orderId;
             [self.navigationController pushViewController:resultVC animated:YES];
             return ;
         }
         repeatCount = 1;
         [self refreshResult];
         self.resultTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshResult) userInfo:nil repeats:YES];
     }andFailureCallback:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return kChargeBatteryTableViewCellHeight;
    }
    else if (indexPath.row == 1)
    {
        return kChargeProduceTableViewCellHeight;
    }
    else if (indexPath.row == 2)
    {
        return kCPChargeInfoTableViewCellHeight;
    }
    return 0.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CPChargeBatteryTableViewCell *cell = [CPChargeBatteryTableViewCell cellWithTableView:tableView];
        cell.second = secondCount;
        if(isStop)
        {
            [cell endAnimation];
        }
        else
        {
            [cell startAnimation];
        }
        return cell;
    }
    else if (indexPath.row == 1)
    {
        CPChargeProduceTableViewCell *cell = [CPChargeProduceTableViewCell cellWithTableView:tableView];
        cell.percent = [produceModel.batteryPercent floatValue];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        CPChargeInfoTableViewCell *cell = [CPChargeInfoTableViewCell cellWithTableView:tableView];
        cell.model = produceModel;
        return cell;
    }
    return nil;
}
- (void)refreshOrderInfo
{
    CPChargeBatteryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.second = secondCount;
    CPChargeProduceTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.percent = [produceModel.batteryPercent floatValue];
    if(secondCount%10 == 0)
    {
        [[ServerFactory getServerInstance:@"CPChargeServer"]doGetChargeInfoWithOrderId:self.orderId andSuccessCallback:^(NSDictionary *callback)
         {
             NSString *status = [callback stringValueForKey:@"status"];
             if([status intValue] == 3)
             {
                 [self inquireAction];
             }
             produceModel.electricCurrent = [callback stringValueForKey:@"i" defaultValue:@""];
             produceModel.voltage = [callback stringValueForKey:@"v" defaultValue:@""];
             produceModel.amountAlectricity = [callback stringValueForKey:@"m" defaultValue:@""];
             produceModel.electricQuantityDegree = [callback stringValueForKey:@"w" defaultValue:@""];
             produceModel.batteryPercent = [callback stringValueForKey:@"r" defaultValue:@""];
             CPChargeInfoTableViewCell *cell = (CPChargeInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
             cell.model = produceModel;
         }andFailureCallback:^(NSString *error)
         {
             NSLog(@"查询订单失败 = %@",error);
         }];
    }
    secondCount ++;
}
#pragma mark - 轮询结果
- (void)refreshResult
{
    if(repeatCount > 24)
    {
        [MBProgressHUD hideHUD];
     //   [CommonMethod showMesg:@"停止充电失败"];
        [self allTimerInvalidate];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLatestChargeOrderId];
        UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
        if([topViewController isEqual:self])
        {
            CPChargeResultViewController *resultVC = [[CPChargeResultViewController alloc]init];
            resultVC.orderId = self.orderId;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
        return ;
    }
    [[ServerFactory getServerInstance:@"CPChargeServer"]doInquireStopChargeResultWithOrderId:self.orderId andSuccessCallback:^(NSDictionary *callback)
     {
         repeatCount ++;
         //1继续轮询
         if([[callback stringValueForKey:@"result" defaultValue:@""] intValue] == 1)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"停止充电成功"];
             [self allTimerInvalidate];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLatestChargeOrderId];
             CPChargeResultViewController *resultVC = [[CPChargeResultViewController alloc]init];
             resultVC.orderId = self.orderId;
             [self.navigationController pushViewController:resultVC animated:YES];
             return ;
         }
         if([[callback stringValueForKey:@"result" defaultValue:@""] intValue] == 2)
         {
             [MBProgressHUD hideHUD];
           //  [CommonMethod showMesg:@"停止充电失败"];
             [self allTimerInvalidate];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLatestChargeOrderId];
             UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
             if([topViewController isEqual:self])
             {
                 CPChargeResultViewController *resultVC = [[CPChargeResultViewController alloc]init];
                 resultVC.orderId = self.orderId;
                 [self.navigationController pushViewController:resultVC animated:YES];
             }
             return ;
         }
     }andFailureCallback:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
        // [CommonMethod showMesg:@"停止充电失败"];
         [self allTimerInvalidate];
         [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLatestChargeOrderId];
         UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
         if([topViewController isEqual:self])
         {
             CPChargeResultViewController *resultVC = [[CPChargeResultViewController alloc]init];
             resultVC.orderId = self.orderId;
             [self.navigationController pushViewController:resultVC animated:YES];
         }
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
