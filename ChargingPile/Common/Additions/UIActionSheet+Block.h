//
//  UIActionSheet+Block.h
//  ChargingPile
//
//  Created by chargingPile on 15/4/14.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIActionSheet (Block)<UIActionSheetDelegate>
- (void)showActionSheetWithClickBlock:(CompleteBlock)block;
@end
