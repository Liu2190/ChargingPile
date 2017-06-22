//
//  CPSearchHistory.m
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/10.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import "CPSearchHistory.h"
#import "FMDatabase.h"

#define kSearchLocationHistoryTable @"t_findpile_search"

@implementation CPPileLocationSearchModel
- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

@end
@implementation CPSearchHistory
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
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_findpile_search (id integer PRIMARY KEY AUTOINCREMENT, locationcity text,locationname text,loactionaddress text,locationlatitude text,locationlongitude text);"];
        if (result) {
            NSLog(@"t_findpile_search成功创表");
        } else {
            NSLog(@"t_findpile_search创表失败");
        }
    }
}

// 获取缓存数据库的所有数据
+ (NSArray *)getAllCachedDataWithCityName:(NSString *)cityName
{
    // 创建数组缓存微博数据
    NSMutableArray *cityArray = [NSMutableArray array];
    // 根据请求参数查询数据
    FMResultSet *resultSet = nil;
    resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_findpile_search  WHERE locationcity == '%@' ORDER BY id",cityName]];
    // 遍历查询结果
    while (resultSet.next) {
        CPPileLocationSearchModel *historyModel = [[CPPileLocationSearchModel alloc] init];
        historyModel.locationCity = [resultSet objectForColumnName:@"locationcity"];
        historyModel.locationName = [resultSet objectForColumnName:@"locationname"];
        historyModel.loactionAddress = [resultSet objectForColumnName:@"loactionaddress"];
        historyModel.locationLatitude = [resultSet objectForColumnName:@"locationlatitude"];
        historyModel.locationLongitude = [resultSet objectForColumnName:@"locationlongitude"];
        [cityArray addObject:historyModel];
    }
    return cityArray;
}

/**
 *  缓存数据到数据库中
 */
+ (void)saveDataWithModel:(CPPileLocationSearchModel *)historyModel
{
    NSMutableArray *cityArray = [NSMutableArray array];
    // 根据请求参数查询数据
    FMResultSet *resultSet = nil;
    resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_findpile_search WHERE loactionaddress = '%@' AND locationname = '%@'",historyModel.loactionAddress,historyModel.locationName]];
    // 遍历查询结果
    while (resultSet.next) {
        CPPileLocationSearchModel *historyModel = [[CPPileLocationSearchModel alloc] init];
        historyModel.locationCity = [resultSet objectForColumnName:@"locationcity"];
        historyModel.locationName = [resultSet objectForColumnName:@"locationname"];
        historyModel.loactionAddress = [resultSet objectForColumnName:@"loactionaddress"];
        historyModel.locationLatitude = [resultSet objectForColumnName:@"locationlatitude"];
        historyModel.locationLongitude = [resultSet objectForColumnName:@"locationlongitude"];
        [cityArray addObject:historyModel];
    }
    if(cityArray.count == 0)
    {
        [_db executeUpdate:@"INSERT INTO t_findpile_search (locationcity, locationname, loactionaddress, locationlatitude,locationlongitude) VALUES (?, ?, ?, ?,?);", historyModel.locationCity,historyModel.locationName,historyModel.loactionAddress,historyModel.locationLatitude,historyModel.locationLongitude];
    }
}

/**
 *  清除搜索历史
 */
+ (void)clearAllCachedData
{
    NSString *sqlstr = @"DELETE FROM t_findpile_search";
    [_db executeUpdate:sqlstr];
}
@end
