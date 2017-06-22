//
//  BeFileHandle.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/6.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "BeFileHandle.h"
#import "SDImageCache.h"

static BeFileHandle *_instance = nil;
@implementation BeFileHandle

+ (BeFileHandle *)sharedInstance
{
    if(_instance == nil)
    {
        @synchronized(self)
        {
            _instance = [[BeFileHandle alloc]init];
        }
    }
    return _instance;
}
- (NSInteger)cacheSize
{
    NSUInteger imageChaheSize = [[SDImageCache sharedImageCache] getSize];
    return imageChaheSize;
}
- (void)clearCache
{
    [self clearCacheWithSuccessBlock:nil andFailBlock:nil];
}
- (void)clearCacheWithSuccessBlock:(void (^)(void))successBlock andFailBlock:(void(^)(void))failBlock
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}
@end
