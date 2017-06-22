//
//  CPAlertView.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/10.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertViewBlock)(void);
@interface CPAlertView : UIView
+ (CPAlertView *)sharedInstance;
- (void)showViewWithTitle:(NSString *)title andContent:(NSString *)content andBlock:(AlertViewBlock)block;
@end
