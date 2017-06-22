//
//  CPMyPileDateTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPileDateModel.h"

#define kCPMyPileDateTableViewCell1Height 49.0
#define kCPMyPileDateTableViewCell2Height 72.0

@interface CPMyPileDateTitleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)UILabel *dateTitleLabel;
@end

@interface CPMyPileDateContentTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)CPPileDateModel *dateModel;
@end
