//
//  CPPileDateModel.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/13.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPPileDateModel : NSObject
@property (nonatomic,strong)NSString *dateId;//	时间段id
@property (nonatomic,strong)NSString *userId;//	用户id
@property (nonatomic,strong)NSString *days;//	周日到周六分别为1,2,3,4,5,6,7，中间用英文逗号分隔
@property (nonatomic,strong)NSString *beginTime;//	开始时间
@property (nonatomic,strong)NSString *endTime;//	结束时间
@property (nonatomic,assign)BOOL selected;
- (void)setDataWithDict:(NSDictionary *)dict;
@end
