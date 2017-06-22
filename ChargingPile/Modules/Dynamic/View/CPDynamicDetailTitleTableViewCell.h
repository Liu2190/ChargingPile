//
//  CPDynamicDetailTitleTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDynamicDetailTitleTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWith:(NSString *)title andTime:(NSString *)time;
- (void)setCellContent:(NSString *)title andTime:(NSString *)time;

@end
