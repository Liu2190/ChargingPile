//
//  CPPileStationListModel.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/17.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPPileStationListModel : NSObject
@property (nonatomic,strong)NSString *address;// = "";
@property (nonatomic,strong)NSString *stationId;// = 1;
@property (nonatomic,strong)NSString *name;// = aaa;
- (id)initWithDict:(NSDictionary *)dict;
@end
