//
//  CPFindPileViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPPileDetailViewController.h"

#import "CPPileListHeaderView.h"
#import "CPFindPileListTableViewCell.h"
#import "CPPileAnnotationView.h"
#import "CPFindPileFooterView.h"
#import "CPFindPileConditionView.h"

#import "CPPileAnnotation.h"
#import "CPPlieModel.h"
#import "CPFindPileCity.h"

#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MapCommonUtility.h"
#import "CPFindPileServer.h"
#import "CMPAccount.h"
#import "NSDictionary+Additions.h"
#import "MJRefresh.h"
#import "CPFindPileDBTool.h"
#import "CPSearchHistory.h"

#define kSimulatorLat 31.226794
#define kSimulatorLng 121.46687

@interface CPFindPileViewController : CPBaseTableViewController<UITextFieldDelegate>
{
    int pageNum;
}
@property (nonatomic,strong)CPPileListHeaderView *headerView;
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)NSString *originalCity;
@property (nonatomic,strong)AMapSearchAPI *mapSearcher;
@property (nonatomic,strong)UIView *mapBgView;
@property (nonatomic,strong)UITableView *searchTableView;

@property (nonatomic,assign)BOOL showList;
@property (nonatomic,strong)NSMutableArray *annotations;
@property (nonatomic,strong)NSString *selectCondition1;
@property (nonatomic,strong)NSString *selectCondition2;
@property (nonatomic,strong)CPPlieModel *selectCondition3;
@property (nonatomic,strong)CPFindPileCity *cityModel;
@property (nonatomic,assign)CLLocationCoordinate2D currentLocation;
@property (nonatomic,strong)NSString *currentAddress;

@property (nonatomic,strong)NSMutableArray *searchResultArray;
@property (nonatomic,strong)NSMutableArray *condition1Array;
@property (nonatomic,strong)NSMutableArray *condition2Array;
@property (nonatomic,strong)NSMutableArray *condition3Array;

- (void)rightAction;
- (void)leftAction;
- (void)startSearchWith:(UITextField *)textField;
- (void)textFiledDoneAction;
- (void)cancelAction;
@end
