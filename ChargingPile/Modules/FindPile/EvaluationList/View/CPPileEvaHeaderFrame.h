//
//  CPPileEvaHeaderFrame.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPPlieModel.h"
@interface CPPileEvaHeaderFrame : NSObject
/**
 *  名称
 */
@property (nonatomic,assign,readonly)CGRect pileNameFrame;
/**
 * 公共站
 */
@property (nonatomic,assign,readonly)CGRect tip1Frame;

/**
 * 有空闲
 */
@property (nonatomic,assign,readonly)CGRect tip2Frame;
/**
 * 地址
 */
@property (nonatomic,assign,readonly)CGRect addressFrame;
/**
 * 评分
 */
@property (nonatomic,assign,readonly)CGRect scoreFrame;
/**
 * 距离
 */
@property (nonatomic,assign,readonly)CGRect distanceFrame;

@property (nonatomic,assign,readonly)CGFloat cellHeight;

@property (nonatomic,strong)CPPlieModel *listModel;
@end
