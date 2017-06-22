//
//  CPPileDetailInfoTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPileDetailInfoTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWith:(NSString *)cellContent;
@end
