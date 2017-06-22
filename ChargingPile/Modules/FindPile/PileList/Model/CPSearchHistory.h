//
//  CPSearchHistory.h
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/10.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPPileLocationSearchModel : NSObject
@property (nonatomic,strong)NSString *locationCity;
@property (nonatomic,strong)NSString *locationName;
@property (nonatomic,strong)NSString *loactionAddress;
@property (nonatomic,strong)NSString *locationLatitude;
@property (nonatomic,strong)NSString *locationLongitude;
@end

@interface CPSearchHistory : NSObject
// 获取缓存数据库的所有数据
+ (NSArray *)getAllCachedDataWithCityName:(NSString *)cityName;

/**
 *  缓存数据到数据库中
 */
+ (void)saveDataWithModel:(CPPileLocationSearchModel *)model;

/**
 *  清除搜索历史
 */
+ (void)clearAllCachedData;
@end


