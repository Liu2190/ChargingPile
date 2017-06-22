//
//  BeGlobalConfigure.h
//  ChargingPile
//
//  Created by chargingPile on 15/4/13.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRequstPageSize 20

@interface BeGlobalConfigure : NSObject
+ (BeGlobalConfigure *)sharedInstance;
- (BOOL)isNetWorkAvailable;
+(NSString*)getErrMsg:(NSString*)aCode;
@end
