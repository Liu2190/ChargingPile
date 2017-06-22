
//
//  CPChargeResultViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeResultViewController.h"

#import "CPChargeBatteryTableViewCell.h"
#import "CPChargeProduceTableViewCell.h"
#import "CPChargeInfoTableViewCell.h"

#import "CPChargeServer.h"
#import "NSDictionary+Additions.h"
#import "CPChargeProduceModel.h"

#define kTitleKey @"titleKey"
#define kContentKey @"contentKey"

@interface CPChargeResultViewController ()
{
    UILabel *electricityLabel;
    int repeatCount;
}
@property (nonatomic,weak)NSTimer *resultTimer;

@end

@implementation CPChargeResultViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self allTimerInvalidate];
}
- (void)allTimerInvalidate
{
    [self.resultTimer invalidate];
    self.resultTimer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
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
    [inquireButton setTitle:@"确定" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
    
    UIImage *bgImage = [UIImage imageNamed:@"03.26"];
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, bgImage.size.height + 20)];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:bgImage];
    bgImageView.centerX = kScreenW/2.0;
    bgImageView.y = 10;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,70,15)];
    contentLabel.centerX = bgImageView.width/2.0;
    contentLabel.centerY = bgImageView.height - 40;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.text = @"充电电量";
    [bgImageView addSubview:contentLabel];
    
    UILabel *title1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,70,15)];
    title1Label.centerX = bgImageView.width - 30;
    title1Label.y = 30;
    title1Label.textColor = [ColorConfigure globalGreenColor];
    title1Label.font = [UIFont systemFontOfSize:12];
    title1Label.text = @"kwh";
    [bgImageView addSubview:title1Label];
    
    electricityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,150,50)];
    electricityLabel.centerX = bgImageView.width/2.0;
    electricityLabel.centerY = bgImageView.height/2.0;
    electricityLabel.textColor = [ColorConfigure globalGreenColor];
    electricityLabel.font = [UIFont systemFontOfSize:40];
    electricityLabel.textAlignment = NSTextAlignmentCenter;
    electricityLabel.text = @"3.26";
    [bgImageView addSubview:electricityLabel];
    [tableHeaderView addSubview:bgImageView];
    self.tableView.tableHeaderView = tableHeaderView;
    
    self.resultTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getData) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
- (void)inquireAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[kTitleKey];
    cell.detailTextLabel.text = dict[kContentKey];
    return cell;
}
- (void)getData
{
    [[ServerFactory getServerInstance:@"CPChargeServer"]doGetChargeResultWithOrderId:self.orderId andSuccessCallback:^(NSDictionary *callback)
     {
         [self.dataArray removeAllObjects];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateStyle:NSDateFormatterMediumStyle];
         [formatter setTimeStyle:NSDateFormatterShortStyle];
         [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
         
         NSDate *dateBegin = [NSDate dateWithTimeIntervalSince1970:[[callback stringValueForKey:@"beginTime"] doubleValue]/1000];
         NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:[[callback stringValueForKey:@"endTime"] doubleValue]/1000];
         if([[callback stringValueForKey:@"beginTime"] length] > 0 && [[callback stringValueForKey:@"endTime"] length] > 0)
         {
             [self allTimerInvalidate];
         }
         NSTimeInterval time = [dateEnd timeIntervalSinceDate:dateBegin];
         
         int hour = (int)(time/3600);
         int minute = (int)(time - hour*3600)/60;
         int second = time - hour*3600 - minute*60;
         int day = 0;
         if(hour > 24)
         {
             day = hour/24;
             hour = hour%24;
         }
         NSString *dateContent = @"";
         if(day > 0 )
         {
             dateContent = [dateContent stringByAppendingString:[NSString stringWithFormat:@"%d天",day]];
         }
         if(hour > 0 )
         {
             dateContent = [dateContent stringByAppendingString:[NSString stringWithFormat:@"%d小时",hour]];
         }
         if(minute > 0 )
         {
             dateContent = [dateContent stringByAppendingString:[NSString stringWithFormat:@"%d分",minute]];
         }
         dateContent = [dateContent stringByAppendingString:[NSString stringWithFormat:@"%d秒",second]];
         [self.dataArray addObject:@{kTitleKey:@"充电金额",kContentKey:[NSString stringWithFormat:@"￥%@",[callback stringValueForKey:@"amount"]]}];
         [self.dataArray addObject:@{kTitleKey:@"订单号",kContentKey:[callback stringValueForKey:@"orderNo"]}];
         [self.dataArray addObject:@{kTitleKey:@"电桩名称",kContentKey:[callback stringValueForKey:@"pileName"]}];
         [self.dataArray addObject:@{kTitleKey:@"开始时间",kContentKey:[formatter stringFromDate:dateBegin]}];
         [self.dataArray addObject:@{kTitleKey:@"结束时间",kContentKey:[formatter stringFromDate:dateEnd]}];
         [self.dataArray addObject:@{kTitleKey:@"充电时长",kContentKey:dateContent}];
         [self.tableView reloadData];
         electricityLabel.text = [callback stringValueForKey:@"quantity"];
         /*
          orderNo	订单号
          quantity	充电量
          beginTime	开始时间
          endTime	结束时间
          pileName	电桩名称
          amount	总金额
          */
       
     }andFailureCallback:^(NSString *error)
     {
         NSLog(@"查询订单失败 = %@",error);
     }];
    repeatCount ++;
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
