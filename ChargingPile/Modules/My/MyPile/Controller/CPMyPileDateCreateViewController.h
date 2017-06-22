//
//  CPMyPileDateCreateViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPPileDateModel.h"

typedef void (^PileDateCreateBlock)(CPPileDateModel *model);
@interface CPMyPileDateCreateViewController : CPBaseTableViewController
@property (nonatomic,copy)PileDateCreateBlock block;
@property (nonatomic,strong)CPPileDateModel *dateModel;
@end
