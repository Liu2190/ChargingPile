//
//  CPMyPileDateViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPPileDateModel.h"

typedef void (^CPMyPileDateBlock)(CPPileDateModel *model);
@interface CPMyPileDateViewController : CPBaseTableViewController
@property (nonatomic,copy)CPMyPileDateBlock block;
@property (nonatomic,strong)CPPileDateModel *selectModel;
@end
