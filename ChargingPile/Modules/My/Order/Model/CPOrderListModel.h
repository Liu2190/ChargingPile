//
//  CPOrderListModel.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,OrderListModelType) {
    OrderListModelTypeUser = 0,//用户订单
    OrderListModelTypePileOwnerWJS = 1,//桩主未结算
    OrderListModelTypePileOwnerYJS = 2,//桩主已结算
};
@interface CPOrderListModel : NSObject
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *displayTime;
@property (nonatomic,strong)NSString *orderStatus;
@property (nonatomic,strong)NSString *orderNo;
@property (nonatomic,strong)NSString *pileName;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *orderIncome;
@property (nonatomic,strong)NSString *amount;//充电金额
@property (nonatomic,strong)NSString *qty;//	充电电量
@property (nonatomic,assign)OrderListModelType type;

- (id)initWith:(NSDictionary *)dict;
@end
