//
//  BeFileHandle.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/6.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeFileHandle : NSObject

+ (BeFileHandle *)sharedInstance;
- (NSInteger)cacheSize;
//- (NSString *)fileSizeString;
- (void)clearCache;

- (void)clearCacheWithSuccessBlock:(void (^)(void))successBlock andFailBlock:(void(^)(void))failBlock;
@end
