//
//  CPPileDetailViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPPlieModel.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger,CPPileDetailViewControllerType) {
    CPPileDetailVCTypeFind,
    CPPileDetailVCTypeFavor,
};
@interface CPPileDetailViewController : CPBaseTableViewController
@property (nonatomic,strong)CPPlieModel *pileModel;
@property (nonatomic,assign)CPPileDetailViewControllerType sourceType;
@property (nonatomic,assign)CLLocationCoordinate2D currentLocation;
@end
