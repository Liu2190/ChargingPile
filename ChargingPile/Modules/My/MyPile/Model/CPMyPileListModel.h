//
//  CPMyPileListModel.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMyPileListModel : NSObject
@property (nonatomic,strong)NSString *pileId;
@property (nonatomic,strong)NSString *stationName;
@property (nonatomic,strong)NSString *pileName;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *displayTime;
@property (nonatomic,strong)NSString *status;
- (id)initWith:(NSDictionary *)dict;

@end
