//
//  CPMyPileDateCreateDatePickerView.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPileStationListModel.h"

typedef void (^DatePickerBlock)(NSInteger index);
@interface CPMyPileDateCreateDatePickerView : UIView
+ (CPMyPileDateCreateDatePickerView *)sharedInstance;
- (void)showPickerViewArray:(NSMutableArray *)datas andSelectIndex:(NSInteger)selectIndex andBlock:(DatePickerBlock)block;

@end
