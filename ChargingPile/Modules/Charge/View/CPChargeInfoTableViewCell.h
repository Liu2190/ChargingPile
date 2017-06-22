//
//  CPChargeInfoTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPChargeProduceModel.h"
#define kCPChargeInfoTableViewCellHeight 130.0f

@interface CPChargeInfoTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)CPChargeProduceModel *model;
@end
