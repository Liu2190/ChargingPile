//
//  CPPileEvaHeaderTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPileEvaHeaderFrame.h"
#import "CPRatingBar.h"

@interface CPPileEvaHeaderTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tip1Label;
@property (nonatomic,strong)UILabel *tip2Label;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *distanceLabel;
@property (nonatomic,strong)CPRatingBar *scoreView;
@property (nonatomic,strong)CPPileEvaHeaderFrame *headerFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
