//
//  CPPileEvalutionModel.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CPPileEvalutionModelType) {
    CPPileEvalutionModelTypePile,
    CPPileEvalutionModelTypeMy,
};

@interface CPPileEvalutionModel : NSObject
@property (nonatomic,assign)CPPileEvalutionModelType type;
@property (nonatomic,strong)NSString *commentId;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *displayTime;
/**
 * 评论id
 */
@property (nonatomic,strong)NSString *evalutionId;
@property (nonatomic,strong)NSString *isReply;
@property (nonatomic,strong)NSArray *reply;
@property (nonatomic,strong)NSString *stationName;
@property (nonatomic,strong)NSString *stationStar;
@property (nonatomic,strong)NSString *types;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userName;
/**
 * 赞的数据
 */
@property (nonatomic,strong)NSMutableArray *thumbupArray;
/**
 * 重复的赞的evalutionId
 */
@property (nonatomic,strong)NSMutableArray *thumbupEvalutionIdArray;
/**
 * 重复的赞的userId
 */
@property (nonatomic,strong)NSMutableArray *thumbupUserIdArray;
/**
 * 回复的数据
 */
@property (nonatomic,strong)NSMutableArray *replyArray;


- (id)initWithDict:(NSDictionary *)dict;

/**
 * 去掉重复的赞
 */
- (void)deleteRepeatThumbup;
@end
