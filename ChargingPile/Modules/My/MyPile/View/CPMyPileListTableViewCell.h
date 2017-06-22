//
//  CPMyPileListTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMyPileListModel.h"

#define kCPMyPileListTableViewCellHeight 260.0f
@interface CPMyPileListTableViewCell : UITableViewCell
@property (nonatomic,strong)CPMyPileListModel *listModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
