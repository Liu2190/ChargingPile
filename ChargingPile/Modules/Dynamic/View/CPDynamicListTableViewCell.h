//
//  CPDynamicListTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDynamicListHeight 92
@interface CPDynamicListTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)UIImageView *listImageView;
@property (nonatomic,strong)UILabel *listTitleLabel;
@property (nonatomic,strong)UILabel *listContentLabel;
@property (nonatomic,strong)UILabel *listtimeLabel;
@end
