//
//  CPFindPileFooterView.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPlieModel.h"
#import "CPRatingBar.h"
#import <MapKit/MapKit.h>

#define kCPFindPileFooterViewHeight 120.0f
@interface CPFindPileFooterView : UIView
/**
 * 名称
 */
@property (nonatomic,strong)UILabel *nameLabel;
/**
 * 品牌
 */
@property (nonatomic,strong)UIImageView *logoImageView;

/**
 * 价格
 */
@property (nonatomic,strong)UILabel *priceLabel;

/**
 * 分数
 */
@property (nonatomic,strong)CPRatingBar *ratingBar;
/**
 * 公共站
 */
@property (nonatomic,strong)UIButton *publicStationButton;
/**
 * 公共站2
 */
@property (nonatomic,strong)UIButton *displayPublicStationButton;
/**
 * 导航
 */
@property (nonatomic,strong)UIButton *navButton;

@property (nonatomic,strong)CPPlieModel *pileModel;

- (void)setViewWith:(CPPlieModel *)model andLocation:(CLLocationCoordinate2D)location;
@end
