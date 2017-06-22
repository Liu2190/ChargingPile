//
//  CPFindPileSearchViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/10.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPSearchHistory.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^CPFindPileSearchViewControllerBlock)(CPPileLocationSearchModel *selectModel);

@interface CPFindPileSearchViewController : CPBaseTableViewController
@property (nonatomic,assign)CLLocationCoordinate2D currentLocation;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,copy)CPFindPileSearchViewControllerBlock block;
@end
