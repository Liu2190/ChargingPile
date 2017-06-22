//
//  CPFindPileCityView.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPFindPileCity.h"
typedef void (^CMPCityPickerViewBlock)(CPFindPileCity *selectModel);

@interface CPFindPileCityView : UIView
+ (CPFindPileCityView *)sharedInstance;
- (void)showPickerViewWithCity:(CPFindPileCity *)cityModel andBlock:(CMPCityPickerViewBlock)block;
@end
