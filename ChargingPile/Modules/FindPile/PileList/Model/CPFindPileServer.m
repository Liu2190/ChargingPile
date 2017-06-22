//
//  CPFindPileServer.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileServer.h"
#import "CPHttp.h"
#import "ServerAPI.h"
#import "CMPAccount.h"

@implementation CPFindPileServer
/**
 * 搜索电站
 */
- (void)doSearchPileWith:(NSString *)name andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/station/api/search/tip"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"name"] = name;
    parameter[@"uid"] = [CMPAccount sharedInstance].accountInfo.uid;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 获取电站列表
 */
- (void)doGetPileListWithLat:(CGFloat )lat andLng:(CGFloat)lng andCity:(NSString *)city andDistance:(NSString *)distance andOperatorId:(NSString *)operatorId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/station/api/search"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"lat"] = [NSNumber numberWithDouble:lat];
    params[@"lng"] = [NSNumber numberWithDouble:lng];
    params[@"city"] = city;
    params[@"distance"] = distance;//[NSNumber numberWithDouble:distance];
    params[@"uid"] = [CMPAccount sharedInstance].accountInfo.uid;
    if(operatorId.length > 0)
    {
        params[@"operator"] = operatorId;
    }
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 添加收藏
 */
- (void)doAddFavorWithStationId:(NSString *)stationId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/station/api/favor"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"stationId"] = stationId;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 取消收藏
 */
- (void)doRemoveFavorWithStationId:(NSString *)stationId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/station/api/delfavor"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"stationId"] = stationId;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 获取电站评论
 */
- (void)doGetPileCommentsWithStationId:(NSString *)stationId  andPageNum:(int)pageNum andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@?page=%d",kServerHost,@"rest/station/api/comments/",stationId,pageNum];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 添加电站评论
 */
- (void)doAddPileCommentWithIsReply:(BOOL )isReply andStationId:(NSString *)stationId andCommentId:(NSString *)commentId andTypes:(int )types andContent:(NSString *)content andSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/station/api/saveCmt"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CMPAccount sharedInstance].accountInfo.uid;
    params[@"isReply"] = [NSNumber numberWithBool:isReply];
    params[@"stationId"] = stationId;
    params[@"commentId"] = commentId;
    params[@"types"] = [NSNumber numberWithInt:types];
    params[@"content"] = content;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:params success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 删除电站评论
 */
- (void)doDeletePileCommentWithId:(NSString *)commentId andSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/station/api/delCmt/%@",kServerHost,commentId];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
- (void)doInquiryOperatorWithSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/user/api/operator",kServerHost];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 获取城市
 */
- (void)getSupportCityWithSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/station/api/city",kServerHost];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
