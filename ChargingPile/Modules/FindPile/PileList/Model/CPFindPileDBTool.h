//
//  CPFindPileDBTool.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPFindPileCity.h"

@interface CPFindPileDBTool : NSObject
// 获取缓存数据库的所有数据
+ (NSArray *)getAllCachedData;

/**
 *  缓存数据到数据库中
 */
+ (void)saveDataWithProvince:(NSString *)province andProvinceCode:(NSString *)provincecode andCityName:(NSString *)cityName andCityCode:(NSString *)cityCode;

/**
 *  缓存数据到数据库中
 */
+ (CPFindPileCity *)inquiryDataWithCityName:(NSString *)cityName;
@end
