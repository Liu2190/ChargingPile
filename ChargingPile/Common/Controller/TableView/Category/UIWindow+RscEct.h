//
//  UIWindow+RscEct.h
//  WePilot
//
//  Created by chargingPile on 14/12/17.
//  Copyright (c) 2014年 wedoauto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (RscEct)
/**
 *
 */
- (UIView *)findFirstResponder;
/**
 *
 */
- (UIView *)findFirstResponderInView:(UIView *)topView;
@end
