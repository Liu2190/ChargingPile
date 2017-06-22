//
//  CPMyPileDetailModel.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMyPileDetailModel : NSObject
@property (nonatomic,strong)NSString *pileId;//	电桩ID
@property (nonatomic,strong)NSString *no;//	电桩编号

@property (nonatomic,strong)NSString *name;//	电桩名称

@property (nonatomic,strong)NSString *serveDays;//	服务时间(周日－周六分别对应为1-7)
@property (nonatomic,strong)NSString *serveTimeBegin;//	服务时间起始几点
@property (nonatomic,strong)NSString *serveTimeEnd;//	服务时间截止几点
@property (nonatomic,strong)NSString *feeJ;//	尖服务费
@property (nonatomic,strong)NSString *feeF;//	峰服务费
@property (nonatomic,strong)NSString *feeP;//	平服务费
@property (nonatomic,strong)NSString *feeG;//	谷服务费

@property (nonatomic,strong)NSString *types;//	电桩类型 0=直流 1=交流
@property (nonatomic,strong)NSString *power;//	功率
@property (nonatomic,strong)NSString *voltage;//	电压
@property (nonatomic,strong)NSString *electricity;//	电流
@property (nonatomic,strong)NSString *stationName;//	站名
@property (nonatomic,strong)NSString *address;//	位置
@property (nonatomic,strong)NSString *userName;//	桩主姓名
@property (nonatomic,strong)NSString *phone;//	桩主电话
@property (nonatomic,strong)NSString *stationId;
@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,strong)NSString *displayTime;
/**
 * 电桩状态
 0	审核中
 1	通过
 2	未通过
 */
@property (nonatomic,strong)NSString *status;
/**
 * 审核拒绝原因
 */
@property (nonatomic,strong)NSString *rejectReason;
- (void)setDataWith:(NSDictionary *)dict;
- (void)setDisplayTimeData;
@end
