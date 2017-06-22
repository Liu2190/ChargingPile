//
//  CPOrderListTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/12.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPOrderListFrame.h"

@interface CPOrderListTableViewCell : UITableViewCell
/**
 *  背景白色图片
 */
@property(nonatomic,strong)UIView *bgView;

/**
 *  分割线
 */
@property(nonatomic,strong)UIView *sepLine;

/**
 *  时间图片
 */
@property(nonatomic,strong)UIImageView *timeImageView;

/**
 *  时间
 */
@property(nonatomic,strong)UILabel *timeLabel;
/**
 *  状态
 */
@property(nonatomic,strong)UILabel *statusLabel;
/**
 *  订单号title
 */
@property(nonatomic,strong)UILabel *orderNumberLabel;
/**
 *  电桩名称title
 */
@property(nonatomic,strong)UILabel *orderNameLabel;
/**
 *  电桩位置title
 */
@property(nonatomic,strong)UILabel *orderAddressLabel;
/**
 * 充电价格title
 */
@property(nonatomic,strong)UILabel *orderPriceLabel;

/**
 *  收益金额title
 */
@property(nonatomic,strong)UILabel *orderIncomeLabel;

/**
 *  订单号
 */
@property(nonatomic,strong)UILabel *orderNumberContentLabel;
/**
 *  电桩名称
 */
@property(nonatomic,strong)UILabel *orderNameContentLabel;
/**
 *  电桩位置
 */
@property(nonatomic,strong)UILabel *orderAddressContentLabel;
/**
 * 充电价格
 */
@property(nonatomic,strong)UILabel *orderPriceContentLabel;

/**
 *  收益金额
 */
@property(nonatomic,strong)UILabel *orderIncomeContentLabel;

/**
 *  红字tip
 */
@property(nonatomic,strong)UILabel *orderTipLabel;

@property (nonatomic,strong)CPOrderListFrame *listFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
