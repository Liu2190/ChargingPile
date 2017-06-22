//
//  CPChargeBatteryTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kChargeBatteryTableViewCellHeight 280
@interface CPChargeBatteryTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)UILabel *hourLabel;
@property (nonatomic,assign)int second;
- (void)startAnimation;
- (void)endAnimation;
@end
