//
//  CPFindPileListTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPlieModel.h"
#import "CPRatingBar.h"

#define kCPFindPileListTableViewCellHeight 310.0f
@interface CPFindPileListTableViewCell : UITableViewCell
/**
 * 列表图片
 */
@property (nonatomic,strong)UIImageView *listImageView;
/**
 * logo
 */
@property (nonatomic,strong)UIImageView *logoImageView;
/**
 * 收藏按钮
 */
@property (nonatomic,strong)UIButton *collectButton;
/**
 * 名称
 */
@property (nonatomic,strong)UILabel *nameLabel;

/**
 * 价格
 */
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIImageView *priceBg;
/**
 * 分数
 */
@property (nonatomic,strong)CPRatingBar *ratingBar;

/**
 * 公共站
 */
@property (nonatomic,strong)UIButton *publicStationButton;
/**
 * 导航
 */
@property (nonatomic,strong)UIButton *navButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)CPPlieModel *listModel;
@end
