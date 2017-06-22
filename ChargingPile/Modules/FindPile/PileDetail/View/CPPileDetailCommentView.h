//
//  CPPileDetailCommentTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/10/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPileEvalutionModel.h"

#define kCPPileDetailCommentViewHeight 200
@interface CPPileDetailCommentView : UIView
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *evalutionLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIButton *moreButton;
@property (nonatomic,strong)UIButton *button1;
@property (nonatomic,strong)UIButton *button2;
- (void)setDataWith:(CPPileEvalutionModel *)model;
@end
