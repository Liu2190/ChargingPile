//
//  CPFindPileViewController+Additions.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileViewController.h"
#import "ServerAPI.h"
#import "CPLoginServer.h"
@interface CPFindPileViewController (Additions)
- (void)initConditionTV;
- (void)getDataWith:(int)currentPage;
- (void)initData;

- (void)refreshAction;
- (void)addMoreAction;
/**
 * 导航
 */
- (void)navigationAciton:(UIButton *)sender;
/**
 * 公共站
 */
- (void)publicStationAction:(UIButton *)sender;
/**
 * 收藏
 */
- (void)collectAction:(UIButton *)sender;

/**
 * 打开定位的提示
 */
- (void)showOpenLocationTip;

/**
 * 添加地图
 */
- (void)addMapView;
/**
 * 地图上设置按钮
 */
- (void)mapViewAddButton;
/**
 * 地图放大
 */
- (void)zoomIn;
/**
 *地图缩小
 */
- (void)zoomOut;
/**
 * 当前位置
 */
- (void)backToTheCurrentPosition;

@end
