//
//  CPSearchConditionView.h
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/19.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kConditionLocation @"找地点"
#define kConditionName @"找名称"

typedef void (^CPSearchConditionViewBlock)(BOOL isNameCondition);
@interface CPSearchConditionBGView : UIView

@end
@interface CPSearchConditionView : UIView
+ (CPSearchConditionView *)sharedInstance;
- (void)showPickerViewWithBlock:(CPSearchConditionViewBlock)block;
@end
