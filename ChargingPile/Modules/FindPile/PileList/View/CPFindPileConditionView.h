//
//  CPFindPileConditionView.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPileListHeaderView.h"

typedef void(^CPFindPileConditionViewBlock) (int selectedIndex);

@interface CPFindPileConditionView : UIView

+ (CPFindPileConditionView *)sharedInstance;
- (void)showViewWith:(NSArray *)reasonArray andSelectIndex:(int)index andBlock:(CPFindPileConditionViewBlock)block;
@end
