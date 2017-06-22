//
//  CPFindPileViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileViewController.h"
#import "CPFindPileViewController+Additions.h"
#import "UIImageView+WebCache.h"
#import "CPFindPileCityView.h"
#import "CPFindPileSearchViewController.h"

#import <CoreLocation/CoreLocation.h>

#define kCalloutViewMargin          -8

@interface CPFindPileViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic,   weak) NSTimer *timer;

@end

@implementation CPFindPileViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showOpenLocationTip];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAction) name:kNotificationLoginSuccess object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (MAMapView *)mapView
{
    if (!_mapView)
    {
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 49 - kCPPileListHeaderViewHeight)];
        _mapView.delegate = self;
        _mapView.rotateCameraEnabled = NO;
        _mapView.rotateEnabled = NO;
        // 3d 图片取消旋转和翻转角度
        _mapView.rotationDegree = 0;
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        _mapView.showsUserLocation = YES;
        _mapView.zoomLevel = 17.1;
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    }
    return _mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConditionTV];
    [self initData];
    [self addMapView];
    self.mapSearcher = [[AMapSearchAPI alloc] init];
    self.mapSearcher.delegate = self;
#if TARGET_IPHONE_SIMULATOR
    self.currentLocation = CLLocationCoordinate2DMake(kSimulatorLat, kSimulatorLng);
    [self refreshAction];
#else
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLeftButtonItem object:nil userInfo:@{kLeftItemCityName:@"定位中"}];
    [MBProgressHUD showMessage:@""];
    [self getCurrentLocation];
#endif
}
#pragma mark - 点击右侧的button
- (void)rightAction
{
    self.mapBgView.hidden = !self.mapBgView.hidden;
    self.tableView.hidden = !self.tableView.hidden;
    self.tableView.mj_footer.hidden = self.tableView.mj_header.hidden = self.tableView.hidden;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRightButtonItem object:nil userInfo:@{@"isMapHidden":[NSNumber numberWithBool:self.mapBgView.hidden]}];
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
            CPPileAnnotation *a1 = self.annotations[0];
            [self.mapView addAnnotations:self.annotations];
            [self.mapView setCenterCoordinate:a1.coordinate animated:YES];
        }
        else
        {
             [self.mapView setCenterCoordinate:self.currentLocation animated:YES];
        }
    }
    else
    {
        self.condition2Array = (NSMutableArray *)@[@"不限",@"价格优先"];
        [self.mapView removeAnnotations:self.annotations];
        [self.annotations removeAllObjects];
    }
}

#pragma mark - 点击左侧的button
- (void)leftAction
{
    [[CPFindPileCityView sharedInstance]showPickerViewWithCity:self.cityModel andBlock:^(CPFindPileCity *selectModel){
        if([selectModel.cityname isEqualToString:self.cityModel.cityname])
        {
            return;
        }
        self.cityModel = selectModel;
        if([self.originalCity isEqualToString:self.cityModel.cityname])
        {
            self.currentLocation = self.mapView.userLocation.coordinate;
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSearchKeywords object:nil userInfo:@{kNotificationSearchKeywords:self.currentAddress}];
            [self refreshCity];
        }
        else
        {
            NSString *oreillyAddress = [NSString stringWithFormat:@"%@ %@ 中国",self.cityModel.cityname,self.cityModel.province];
            if([self.cityModel.cityname isEqualToString:self.cityModel.province])
            {
                oreillyAddress = [NSString stringWithFormat:@"%@ 中国",self.cityModel.cityname];
            }
            CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
            [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
                if ([placemarks count] > 0 && error == nil) {
                    NSLog(@"Found %lu placemark(s).", (unsigned long        )[placemarks count]);
                    CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                    NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
                    NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
                    self.currentLocation = firstPlacemark.location.coordinate;
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSearchKeywords object:nil userInfo:@{kNotificationSearchKeywords:self.cityModel.cityname}];
                    [self refreshCity];
                }
                else if ([placemarks count] == 0 && error == nil) {
                    NSLog(@"Found no placemarks.");
                } else if (error != nil) {
                    NSLog(@"An error occurred = %@", error);
                }  
            }];
        }
    }];
}
#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchTableView)
    {
        return self.searchResultArray.count;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView == self.searchTableView?44.0: kCPFindPileListTableViewCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        CPFindPileListTableViewCell *cell = [CPFindPileListTableViewCell cellWithTableView:tableView];
        cell.listModel = self.dataArray[indexPath.row];
        cell.navButton.tag = indexPath.row;
        [cell.navButton addTarget:self action:@selector(navigationAciton:) forControlEvents:UIControlEventTouchUpInside];
        cell.collectButton.tag = 1000 + indexPath.row;
        [cell.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.publicStationButton.tag = 2000 + indexPath.row;
        [cell.publicStationButton addTarget:self action:@selector(publicStationAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (tableView == self.searchTableView)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        CPPlieModel *listModel = self.searchResultArray[indexPath.row];
        cell.textLabel.text = listModel.name;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.tableView)
    {
        CPPileDetailViewController *detailVC = [[CPPileDetailViewController alloc]init];
        detailVC.sourceType = CPPileDetailVCTypeFind;
        detailVC.pileModel = self.dataArray[indexPath.row];
        detailVC.currentLocation = self.currentLocation;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (tableView == self.searchTableView)
    {
        CPPileDetailViewController *detailVC = [[CPPileDetailViewController alloc]init];
        detailVC.sourceType = CPPileDetailVCTypeFind;
        detailVC.pileModel = self.searchResultArray[indexPath.row];
        detailVC.currentLocation = self.currentLocation;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([annotation isKindOfClass:[CPPileAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CPPileAnnotationView *annotationView = (CPPileAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CPPileAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        CPPileAnnotation *pileAnnotation = (CPPileAnnotation *)annotation;
        annotationView.imageUrl     = [NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,pileAnnotation.pileModel.userId];
        return annotationView;
    }
    else
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout               = NO;
        annotationView.draggable                    = NO;
        annotationView.image                     = [UIImage imageNamed:@"pileAnnotation"];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"accessory view :%@", view);
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    NSLog(@"old :%ld - new :%ld", (long)oldState, (long)newState);
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
    NSLog(@"callout view :%@", view);
}

- (CGPoint)randomPoint
{
    CGPoint randomPoint = CGPointZero;
    randomPoint.x = arc4random() % (int)(CGRectGetWidth(self.view.bounds));
    randomPoint.y = arc4random() % (int)(CGRectGetHeight(self.view.bounds));
    return randomPoint;
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark - Action Handle
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
   if([view.reuseIdentifier isEqualToString:@"customReuseIndetifier"])
    {
        if ([view isKindOfClass:[CPPileAnnotationView class]])
        {
            [self endEdit];
        }
    }
    else
    {
    }
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[CPPileAnnotationView class]])
    {
        CPPileAnnotationView *cusView = (CPPileAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        if(cusView.selected)
        {
            NSInteger index = [self.annotations indexOfObject:cusView.annotation];
            [self selectPileWith:index];
        }
    }
}

- (void)selectPileWith:(NSInteger)index
{
    [self endEdit];
    CPPileAnnotation *selectModel = [self.annotations objectAtIndex:index];
    CPFindPileFooterView *footerView = [[CPFindPileFooterView alloc]initWithFrame:CGRectMake(0, kScreenH - 64 - 49 - kCPFindPileFooterViewHeight, kScreenW, kCPFindPileFooterViewHeight)];
    [footerView setViewWith:selectModel.pileModel andLocation:self.currentLocation];
    footerView.publicStationButton.tag = footerView.displayPublicStationButton.tag =  2000 + index;
    footerView.navButton.tag = index;
    [footerView.publicStationButton addTarget:self action:@selector(publicStationAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.displayPublicStationButton addTarget:self action:@selector(publicStationAction:) forControlEvents:UIControlEventTouchUpInside];

    [footerView.navButton addTarget:self action:@selector(navigationAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerView];
}

#pragma mark - textFieldDelegate
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = noti.object;
    if(tf.text.length < 2)
    {
        return;
    }
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doSearchPileWith:tf.text andSuccessCallback:^(id callback)
     {
         NSLog(@"搜索充电站 = %@",callback);
         [self.searchResultArray removeAllObjects];
         if([callback isKindOfClass:[NSArray class]])
         {
             for(NSDictionary *member in callback)
             {
                 CPPlieModel *listModel = [[CPPlieModel alloc]initWithDict:member];
                 [self.searchResultArray addObject:listModel];
             }
             [self.searchTableView reloadData];
             if(self.searchTableView.hidden == YES)
             {
                 self.searchTableView.hidden = NO;
             }
         }
         else if ([callback isKindOfClass:[NSDictionary class]])
         {
             if([callback arrayValueForKey:@"list"].count > 0)
             {
                 for(NSDictionary *member in [callback arrayValueForKey:@"list"])
                 {
                     CPPlieModel *listModel = [[CPPlieModel alloc]initWithDict:member];
                     [self.searchResultArray addObject:listModel];
                 }
                 [self.searchTableView reloadData];
                 if(self.searchTableView.hidden == YES)
                 {
                     self.searchTableView.hidden = NO;
                 }
             }
         }
         
     }andFailureCallback:^(NSString *error)
     {
         NSLog(@"搜索失败 = %@",error);
     }];
}

- (void)textFiledDoneAction
{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
}
- (void)startSearchWith:(UITextField *)textField
{
    CPFindPileSearchViewController *searchVC = [[CPFindPileSearchViewController alloc]init];
    searchVC.cityName = self.cityModel.cityname;
    searchVC.currentLocation = self.currentLocation;
    searchVC.block = ^(CPPileLocationSearchModel *selectModel)
    {
        self.currentLocation = CLLocationCoordinate2DMake(selectModel.locationLatitude.floatValue, selectModel.locationLongitude.floatValue);
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(selectModel.locationLatitude.floatValue, selectModel.locationLongitude.floatValue) animated:YES];
        self.mapView.zoomLevel = 17.8;
    };
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 清除
- (void)endEdit
{
    for(CPFindPileFooterView *footerView in [self.view subviews])
    {
        if([footerView isKindOfClass:[CPFindPileFooterView class]])
        {
            [footerView removeFromSuperview];
        }
    }
}
#pragma mark - 获取城市名称，获取经纬度
- (void)getCurrentLocation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction
{
    CLLocationCoordinate2D centerCoordinate = self.mapView.userLocation.location.coordinate;
    if (centerCoordinate.latitude != 0) {
        self.currentLocation = centerCoordinate;
        [self.timer invalidate];
        self.timer = nil;
        [self getLocationWithLocation:centerCoordinate];
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {   // 没有打开定位的情况
        
        [self.timer invalidate];
        self.timer = nil;
        [MBProgressHUD hideHUD];
        [self showOpenLocationTip];
    }
}
- (void)getLocationWithLocation:(CLLocationCoordinate2D )Coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:Coordinate.latitude longitude:Coordinate.longitude];
    regeo.radius = 100 ;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [self.mapSearcher AMapReGoecodeSearch:regeo];
}
// 高德地图 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        NSString *cityName = @"";
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        if (response.regeocode.pois.count > 0) {
            AMapPOI *testMapPOI = [[AMapPOI alloc] init];
            for (AMapPOI *mapPOI in response.regeocode.pois) {
                if ([mapPOI.type isEqualToString:@"商务住宅;楼宇;商务写字楼"]) {
                    testMapPOI = mapPOI;
                    break;
                }
            }
            
            if (testMapPOI.name.length == 0) {
                testMapPOI = response.regeocode.pois.firstObject;
            }
            self.currentAddress = testMapPOI.name;
            if (response.regeocode.addressComponent.city.length == 0) {
                cityName = response.regeocode.addressComponent.province;
            } else {
                cityName = response.regeocode.addressComponent.city;
            }
        } else {
            if (response.regeocode.formattedAddress.length != 0)
            {
                self.currentAddress = response.regeocode.formattedAddress;
                if (response.regeocode.addressComponent.city.length == 0) {
                    cityName = response.regeocode.addressComponent.province;
                } else {
                    cityName = response.regeocode.addressComponent.city;
                }
            } else {
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSearchKeywords object:nil userInfo:@{kNotificationSearchKeywords:self.currentAddress}];

        self.originalCity = [cityName mutableCopy];
        self.cityModel = [CPFindPileDBTool inquiryDataWithCityName:cityName];
        [MBProgressHUD hideHUD];
        [self refreshCity];
    }
}
- (void)refreshCity
{
    [self refreshAction];
    if(self.cityModel.cityname != nil && self.cityModel.cityname.length > 0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLeftButtonItem object:nil userInfo:@{kLeftItemCityName:self.cityModel.cityname}];
    }
}
- (void)cancelAction
{
    [self.view endEditing:YES];
    self.searchTableView.hidden = YES;
    [self.searchResultArray removeAllObjects];
    [self.searchTableView reloadData];
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
