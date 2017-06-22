//
//  CPPileEvalutionTitleCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRatingBar.h"
#import "CPPileEvalutionTitleFrame.h"

@interface CPPileEvalutionTitleCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)CPRatingBar *scoreView;
@property (nonatomic,strong)UILabel *evalutionLabel;
@property (nonatomic,strong)UIButton *deleteButton;
@property (nonatomic,strong)UIButton *thumbUpButton;
@property (nonatomic,strong)UIButton *commentButton;
@property (nonatomic,strong)CPPileEvalutionTitleFrame *titleFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
