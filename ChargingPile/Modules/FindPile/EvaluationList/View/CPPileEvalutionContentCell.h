//
//  CPPileEvalutionContentCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPileEvalutionContentFrame.h"
@interface CPPileEvalutionContentCell : UITableViewCell
@property (nonatomic,strong)UILabel *replyLabel;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UILabel *thumbUpLabel;
@property (nonatomic,strong)CPPileEvalutionContentFrame *contenFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
