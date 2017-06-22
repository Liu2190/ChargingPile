//
//  CPDynamicDetailContentTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDynamicDetailContentTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *contentLabel;

+ (CGFloat)cellHeightWith:(NSString *)content;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellContent:(NSString *)content;
@end
