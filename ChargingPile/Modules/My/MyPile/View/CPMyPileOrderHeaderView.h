//
//  CPMyPileOrderHeaderView.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/10.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPOrderListModel.h"

#define kCPMyPileOrderHeaderViewHeight 44.0f

@interface CPMyPileOrderHeaderView : UIView
@property (nonatomic,assign)OrderListModelType type;
- (void)addTarget:(id)target andWJS:(SEL)wjsAction andYJS:(SEL)yjsAction;
@end
