//
//  CPFindPileDBTool.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileDBTool.h"
#import "FMDatabase.h"
#import "CMPAccount.h"


@implementation CPFindPileDBTool
/** 数据库实例 */
static FMDatabase *_db;

+ (void)initialize
{
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"findpile.sqlite"];
    NSLog(@"沙盒路径：%@",filename);
    // 2.得到数据库
    _db = [FMDatabase databaseWithPath:filename];
    // 3.打开数据库
    if ([_db open]) {
        // 4.创表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_findpile_city (id integer PRIMARY KEY AUTOINCREMENT, province text,provincecode text,cityname text,citycode text);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
}

/**
 *  通过请求参数去数据库中加载所有缓存数据
 *
 *  @param param 请求参数
 */
+ (NSArray *)getAllCachedData
{
    // 创建数组缓存微博数据
    NSMutableArray *cityArray = [NSMutableArray array];
    // 根据请求参数查询数据
    FMResultSet *resultSet = nil;
    resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT id,province,provincecode, cityname, citycode FROM t_findpile_city ORDER BY id"]];
    // 遍历查询结果
    while (resultSet.next) {
        CPFindPileCity *cityModel = [[CPFindPileCity alloc] init];
        cityModel.province = [resultSet objectForColumnName:@"province"];
        cityModel.provincecode = [[resultSet objectForColumnName:@"provincecode"] intValue];
        cityModel.cityname = [resultSet objectForColumnName:@"cityname"];
        cityModel.citycode = [resultSet objectForColumnName:@"citycode"];
        [cityArray addObject:cityModel];
    }
    return cityArray;
}

/**
 *  缓存字典数组到数据库中
 */
+ (void)saveDataWithProvince:(NSString *)province andProvinceCode:(NSString *)provincecode andCityName:(NSString *)cityName andCityCode:(NSString *)cityCode
{
    [_db executeUpdate:@"INSERT INTO t_findpile_city (province, provincecode, cityname, citycode) VALUES (?, ?, ?, ?);", province,provincecode,cityName,cityCode];
}
/**
 *  缓存数据到数据库中
 */
+ (CPFindPileCity *)inquiryDataWithCityName:(NSString *)cityName
{
    NSMutableArray *cityArray = [NSMutableArray array];
    // 根据请求参数查询数据
    FMResultSet *resultSet = nil;
    resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_findpile_city where cityname = '%@'",cityName]];
    // 遍历查询结果
    while (resultSet.next) {
        CPFindPileCity *cityModel = [[CPFindPileCity alloc] init];
        cityModel.province = [resultSet objectForColumnName:@"province"];
        cityModel.provincecode = [[resultSet objectForColumnName:@"provincecode"] intValue];
        cityModel.cityname = [resultSet objectForColumnName:@"cityname"];
        cityModel.citycode = [resultSet objectForColumnName:@"citycode"];
        [cityArray addObject:cityModel];
    }
    return (cityArray.count > 0)?cityArray[0]:nil;
}
@end
