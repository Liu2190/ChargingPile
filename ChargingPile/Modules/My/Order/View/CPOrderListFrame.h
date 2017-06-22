//
//  CPOrderListFrame.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPOrderListModel.h"
@interface CPOrderListFrame : NSObject

/**
 *  背景白色图片
 */
@property(nonatomic,assign,readonly)CGRect bgViewframe;

/**
 *  分割线
 */
@property(nonatomic,assign,readonly)CGRect sepLineframe;

/**
 *  时间图片
 */
@property(nonatomic,assign,readonly)CGRect timeImageViewframe;

/**
 *  时间
 */
@property(nonatomic,assign,readonly)CGRect timeLabelframe;

/**
 *  状态
 */
@property(nonatomic,assign,readonly)CGRect statusLabelframe;
/**
 *  订单号title
 */
@property(nonatomic,assign,readonly)CGRect orderNumberframe;
/**
 *  电桩名称title
 */
@property(nonatomic,assign,readonly)CGRect orderNameframe;
/**
 *  电桩位置title
 */
@property(nonatomic,assign,readonly)CGRect orderAddressframe;
/**
 * 充电价格title
 */
@property(nonatomic,assign,readonly)CGRect orderPriceframe;

/**
 *  收益金额title
 */
@property(nonatomic,assign,readonly)CGRect orderIncomeframe;

/**
 *  订单号
 */
@property(nonatomic,assign,readonly)CGRect orderNumberContentframe;
/**
 *  电桩名称
 */
@property(nonatomic,assign,readonly)CGRect orderNameContentframe;
/**
 *  电桩位置
 */
@property(nonatomic,assign,readonly)CGRect orderAddressContentframe;
/**
 * 充电价格
 */
@property(nonatomic,assign,readonly)CGRect orderPriceContentframe;

/**
 *  收益金额
 */
@property(nonatomic,assign,readonly)CGRect orderIncomeContentframe;

/**
 *  红字tip
 */
@property(nonatomic,assign,readonly)CGRect orderTipLabelframe;
 ;

/**
 * 图片高度
 */
@property(nonatomic,assign,readonly)CGFloat cellHeight;

@property (nonatomic,strong)CPOrderListModel *listModel;

@end
