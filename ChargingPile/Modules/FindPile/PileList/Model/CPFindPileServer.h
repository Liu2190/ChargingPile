//
//  CPFindPileServer.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPFindPileServer : NSObject
/**
 * 搜索电站
 */
- (void)doSearchPileWith:(NSString *)name andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 获取电站列表
 */
- (void)doGetPileListWithLat:(CGFloat )lat andLng:(CGFloat)lng andCity:(NSString *)city andDistance:(NSString *)distance andOperatorId:(NSString *)operatorId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;

/**
 * 添加收藏
 */
- (void)doAddFavorWithStationId:(NSString *)stationId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 取消收藏
 */
- (void)doRemoveFavorWithStationId:(NSString *)stationId andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;

/**
 * 获取电站评论
 */
- (void)doGetPileCommentsWithStationId:(NSString *)stationId  andPageNum:(int)pageNum andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 添加电站评论
 */
- (void)doAddPileCommentWithIsReply:(BOOL )isReply  andStationId:(NSString *)stationId andCommentId:(NSString *)commentId andTypes:(int )types andContent:(NSString *)content andSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure;

/**
 * 删除电站评论
 */
- (void)doDeletePileCommentWithId:(NSString *)commentId andSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure;
/**
 * 查询运营商列表
 */
- (void)doInquiryOperatorWithSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure;
/**
 * 获取城市
 */
- (void)getSupportCityWithSuccessCallback:(void (^)(id))callback andFailureCallback:(void (^)(id))failure;
@end
