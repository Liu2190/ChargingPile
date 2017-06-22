//
//  UIAlertView+Block.h
//  SideBenefit
//
//  Created by chargingPile on 15/3/6.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)

- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;

@end
