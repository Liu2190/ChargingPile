//
//  CPFindPileViewController+Additions.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileViewController+Additions.h"
#import "CPPlieModel.h"

#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "MapCommonUtility.h"
#import "CPFindPileServer.h"
#import "CMPAccount.h"
#import "NSDictionary+Additions.h"

@implementation CPFindPileViewController (Additions)

- (void)getDataWith:(int)currentPage
{
    [MBProgressHUD showMessage:@""];
    NSString *distance = @"100";
    if([self.selectCondition1 isEqualToString:self.condition1Array[0]])
    {
        distance = @"100";
    }
    else if([self.selectCondition1 isEqualToString:self.condition1Array[1]])
    {
        distance = @"0.5";
    }else if([self.selectCondition1 isEqualToString:self.condition1Array[2]])
    {
        distance = @"1";
    }else if([self.selectCondition1 isEqualToString:self.condition1Array[3]])
    {
        distance = @"2";
    }else if([self.selectCondition1 isEqualToString:self.condition1Array[4]])
    {
        distance = @"5";
    }
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doGetPileListWithLat:self.currentLocation.latitude andLng:self.currentLocation.longitude andCity:self.cityModel.citycode andDistance:distance andOperatorId:self.selectCondition3.pileId andSuccessCallback:^(NSArray *callback)
     {
         [MBProgressHUD hideHUD];
         [self.tableView.mj_header endRefreshing];
         NSLog(@"获取站 = %@",callback);

         if(currentPage == 1)
         {
             [self.dataArray removeAllObjects];
         }
         if([callback count] == 0)
         {
             if(pageNum > 1)
             {
                 pageNum--;
             }
             if(self.mapBgView.hidden == NO)
             {
                 self.condition2Array = (NSMutableArray *)@[@"不限"];
                 [self.mapView removeAnnotations:self.annotations];
                 [self.annotations removeAllObjects];
                 [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
             }
             [self.tableView reloadData];
             return ;
         }
         
         for(NSDictionary *member in callback)
         {
             CPPlieModel *listModel = [[CPPlieModel alloc]initWithDict:member];
             [listModel getDistanceWithLocation:self.currentLocation];
             [self.dataArray addObject:listModel];
         }
         if([self.selectCondition2 isEqualToString:@"价格优先"])
         {
             NSArray *tempArray = [self.dataArray mutableCopy];
             [self.dataArray removeAllObjects];
             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"pilePrice" ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObjects:descriptor, nil];
             NSArray *allArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
             [self.dataArray addObjectsFromArray:allArray];
         }
         [self.tableView reloadData];
         if(self.mapBgView.hidden == NO)
         {
             self.condition2Array = (NSMutableArray *)@[@"不限"];
             [self.mapView removeAnnotations:self.annotations];
             [self.annotations removeAllObjects];
             for (int i = 0; i < self.dataArray.count; i++)
             {
                 CPPileAnnotation *a1 = [[CPPileAnnotation alloc] init];
                 CPPlieModel *pileModel = self.dataArray[i];
                 a1.pileModel = pileModel;
                 a1.index = i;
                 a1.coordinate = CLLocationCoordinate2DMake([pileModel.lat doubleValue], [pileModel.lng doubleValue]);
                 [self.annotations addObject:a1];
             }
             if(self.dataArray.count > 1)
             {
                 [self.mapView addAnnotations:self.annotations];
                // [self.mapView setVisibleMapRect:[MapCommonUtility minMapRectForAnnotations:self.annotations]];
                 [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
             }
             else if(self.dataArray.count == 1)
             {
                 [self.mapView addAnnotations:self.annotations];
                 CPPileAnnotation *a1 = self.annotations[0];
                 [self.mapView setCenterCoordinate:a1.coordinate animated:YES];
             }
             else
             {
                 [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
             }

         }
     }andFailureCallback:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"获取失败"];
         if(pageNum > 1){
             pageNum -- ;
         }
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_header endRefreshing];
         if(currentPage == 1)
         {
             [self.dataArray removeAllObjects];
         }
         [self.tableView reloadData];
     }];
}
- (void)initData
{
    self.originalCity = @"";
    self.currentAddress = [[NSString alloc]init];
    self.cityModel = [[CPFindPileCity alloc]init];
    self.cityModel.cityname = @"北京";
    self.cityModel.citycode = @"1";
    self.condition1Array = (NSMutableArray *)@[@"不限",@"500m",@"1km",@"2km",@"5km"];
    self.condition2Array = (NSMutableArray *)@[@"不限",@"价格优先"];
    self.condition3Array = [[NSMutableArray alloc]init];;
    CPPlieModel *firstModel = [[CPPlieModel alloc]init];
    firstModel.pileId = @"";
    firstModel.name = @"不限";
    [self.condition3Array addObject:firstModel];
    self.showList = NO;
    self.annotations = [[NSMutableArray alloc]init];
    self.selectCondition1 = self.condition1Array[0];
    self.selectCondition2 = self.condition2Array[0];
    self.selectCondition3 = self.condition3Array[0];
    self.searchResultArray = [[NSMutableArray alloc]init];
    pageNum = 1,

    self.tableView.frame = CGRectMake(0, kCPPileListHeaderViewHeight, kScreenW, kScreenH - 64 - 49 - kCPPileListHeaderViewHeight);
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
  //  self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
    [self inquiryOperator];
    // Do any additional setup after loading the view.
}
- (void)inquiryOperator
{
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doInquiryOperatorWithSuccessCallback:^(NSArray *callback)
     {
         NSLog(@"运营商%@",callback);
         for(NSDictionary *member in callback)
         {
             CPPlieModel *operatorModel = [[CPPlieModel alloc]initWithDict:member];
             [self.condition3Array addObject:operatorModel];
         }
     }andFailureCallback:^(NSString *error)
     {
         NSLog(@"错误%@",error);
     }];
}
- (void)refreshAction
{
    pageNum = 1;
    [self getDataWith:pageNum];
}
- (void)addMoreAction
{
    pageNum ++;
    [self getDataWith:pageNum];
}
- (void)initConditionTV
{
    self.headerView = [[CPPileListHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kCPPileListHeaderViewHeight)];
    [self.view addSubview:self.headerView];
    for(UIButton *subButton in self.headerView.subviews)
    {
        if([subButton isKindOfClass:[UIButton class]])
        {
            [subButton addTarget:self action:@selector(conditionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 49)  style:UITableViewStylePlain];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    [self.view addSubview:self.searchTableView];
    self.searchTableView.hidden = YES;
}
#pragma mark - 显示筛选的view
- (void)conditionButtonAction:(UIButton *)sender
{
    NSArray *conditionArray = [NSArray array];
    int selectIndex = 0;
    if(sender.tag == 0)
    {
        conditionArray = [self.condition1Array mutableCopy];
        selectIndex = (int)[self.condition1Array indexOfObject:self.selectCondition1];
    }
    else if (sender.tag == 1)
    {
        conditionArray = [self.condition2Array mutableCopy];
        selectIndex = (int)[self.condition2Array indexOfObject:self.selectCondition2];
    }
    else if (sender.tag == 2)
    {
        conditionArray = [self.condition3Array mutableCopy];
        selectIndex = (int)[self.condition3Array indexOfObject:self.selectCondition3];
    }
    [[CPFindPileConditionView sharedInstance]showViewWith:conditionArray andSelectIndex:selectIndex andBlock:^(int index)
    {
        NSLog(@"选中 = %d",index);
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
        {
            // 没有打开定位的情况
            return;
        }
        if(index == selectIndex)
        {
            return ;
        }
        if(sender.tag == 0)
        {
            self.selectCondition1 = [self.condition1Array objectAtIndex:index];
        }
        else if (sender.tag == 1)
        {
            self.selectCondition2 = [self.condition2Array objectAtIndex:index];
        }
        else if (sender.tag == 2)
        {
            self.selectCondition3 = [self.condition3Array objectAtIndex:index];
        }
        pageNum = 1;
        [self getDataWith:pageNum];
    }];
}
- (void)navigationAciton:(UIButton *)sender
{
    CPPlieModel *listModel = self.dataArray[sender.tag];
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([listModel.lat doubleValue], [listModel.lng doubleValue]);
    [[MapCommonUtility sharedInstance]showNavigationSheetWithCurrentLocation:self.currentLocation andDestinationLocaiton:destination andDestinationTitle:listModel.name];
}
- (void)publicStationAction:(UIButton *)sender
{
    [self tableView:self.tableView didSelectRowAtIndexPath:    [NSIndexPath indexPathForRow:sender.tag - 2000 inSection:0]];
}
- (void)collectAction:(UIButton *)sender
{
    CPPlieModel *listModel = self.dataArray[sender.tag - 1000];
    if(listModel.isFavor)
    {
        //取消收藏
        [MBProgressHUD showMessage:@""];
        [[ServerFactory getServerInstance:@"CPFindPileServer"]doRemoveFavorWithStationId:listModel.pileId andSuccessCallback:^(NSDictionary *callback)
         {
             [MBProgressHUD hideHUD];

             NSLog(@"取消收藏 = %@",callback);
             if([[callback objectForKey:@"state"] intValue] == 0)
             {
                 listModel.isFavor = !listModel.isFavor;
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
        [MBProgressHUD showMessage:@""];
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
- (void)showOpenLocationTip
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {   // 没有打开定位的情况
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLeftButtonItem object:nil userInfo:@{kLeftItemCityName:@"定位失败"}];
        NSString *tip = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-定位服务”选项中打开定位服务，并允许%@使用定位服务。", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleDisplayName"]];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:tip message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [al show];
    }
}
- (void)addMapView
{
    self.mapBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kCPPileListHeaderViewHeight, kScreenW, kScreenH - 64 - 49 - kCPPileListHeaderViewHeight)];
    [self.view addSubview:self.mapBgView];
    self.mapView.frame = self.mapBgView.bounds;
    [self.mapBgView addSubview:self.mapView];
    [self mapViewAddButton];
    self.mapBgView.hidden = YES;
}
- (void)mapViewAddButton
{
    for(int i = 0;i< 3;i++)
    {
        UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [inquireButton setBackgroundColor:[UIColor whiteColor]];
        inquireButton.titleLabel.font = [UIFont fontWithName:@"CourierNewPSMT" size:38];
        [inquireButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        inquireButton.layer.cornerRadius = 2.0f;
        inquireButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        inquireButton.layer.borderWidth = 0.7;
        if(i == 0)
        {
            [inquireButton setImage:[UIImage imageNamed:@"spe_wheel"] forState:UIControlStateNormal];
            inquireButton.frame = CGRectMake(10, self.mapView.height - 100, 40, 40);
            [inquireButton addTarget:self action:@selector(backToTheCurrentPosition) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i == 1)
        {
            [inquireButton setTitle:@"+"forState:UIControlStateNormal];
            inquireButton.frame = CGRectMake(self.mapView.width - 50, self.mapView.height/2.0, 40, 40);
            [inquireButton addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 2)
        {
            [inquireButton setTitle:@"-"forState:UIControlStateNormal];
            inquireButton.frame = CGRectMake(self.mapView.width - 50, self.mapView.height/2.0 + 45, 40, 40);
            [inquireButton addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.mapView addSubview:inquireButton];
    }
}
/**
 * 地图放大
 */
- (void)zoomIn
{
    CGFloat level = self.mapView.zoomLevel;
    level ++;
    [self.mapView setZoomLevel:level animated:YES];
}
/**
 *地图缩小
 */
- (void)zoomOut
{
    CGFloat level = self.mapView.zoomLevel;
    level --;
    [self.mapView setZoomLevel:level animated:YES];
}
/**
 * 当前位置
 */
- (void)backToTheCurrentPosition
{
    if([self.originalCity isEqualToString:self.cityModel.cityname])
    {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
    else
    {
        [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
    }
    self.mapView.zoomLevel = 17.1;
}

@end
