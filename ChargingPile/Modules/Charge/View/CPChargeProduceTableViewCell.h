//
//  CPChargeProduceTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kChargeProduceTableViewCellHeight 60.0f
@interface CPChargeProduceTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)CGFloat percent;//百分比
@end
