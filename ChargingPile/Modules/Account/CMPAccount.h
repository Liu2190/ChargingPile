//
//  CMPAccount.h
//  chargingPile
//
//  Created by RobinLiu on 15/9/8.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPAccountInfo.h"

@interface CMPAccount : NSObject
@property (nonatomic,strong)CMPAccountInfo *accountInfo;
+ (CMPAccount *)sharedInstance;
@end
