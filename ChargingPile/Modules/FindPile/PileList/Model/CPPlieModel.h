//
//  CPPlieModel.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CPPlieModel : NSObject

@property (nonatomic,strong)NSString *pileId;//	充电站id
@property (nonatomic,strong)NSString *pilePrice;//	充电站价格

@property (nonatomic,assign)BOOL isFavor;//是否被收藏
@property (nonatomic,strong)NSString *no;//	充电站编号
@property (nonatomic,strong)NSString *name;//	充电站名称
@property (nonatomic,strong)NSString *contact;//	联系人
@property (nonatomic,strong)NSString *phone;//	联系电话
@property (nonatomic,strong)NSString *types;//	电站类型(见码表)0-公用 1-专用 2私人
@property (nonatomic,strong)NSString *dianzhanType;
@property (nonatomic,strong)NSString *userId;//	运营商id
@property (nonatomic,strong)NSString *lng;//	纬度
@property (nonatomic,strong)NSString *lat;//	经度
@property (nonatomic,strong)NSString *province;//	省
@property (nonatomic,strong)NSString *city;//	市
@property (nonatomic,strong)NSString *district;//	区
@property (nonatomic,strong)NSString *address;//	地址
@property (nonatomic,strong)NSString *star;//	星级
@property (nonatomic,strong)NSString *provinceName;//	省中文名
@property (nonatomic,strong)NSString *cityName;//	市中文名
@property (nonatomic,strong)NSString *districtName;//	区中文名
@property (nonatomic,strong)NSString *operatorName;//	运营商中文名
@property (nonatomic,strong)NSString *icon;//	/rest/station/icon/{id}  GET请求
@property (nonatomic,strong)NSString *idle;//	空闲电桩数量
@property (nonatomic,strong)NSString *idleJiaLiu;//	空闲交流桩数量
@property (nonatomic,strong)NSString *idleZhiLiu;//	空闲直流桩数量
@property (nonatomic,strong)NSString *jiaoLiu;//	交流桩数量
@property (nonatomic,strong)NSString *zhiLiu;//	直流桩数量
@property (nonatomic,strong)NSData *imageData;
@property (nonatomic,strong)NSString *photo;//	市中文名

@property (nonatomic,strong)NSString *operatorLogo;//	/rest/user/icon/{userId}  GET请求
/**
 * 距离显示
 */
@property (nonatomic,strong)NSString *distanceAppearance;

@property (nonatomic,strong)NSString *jian;//	尖电价
@property (nonatomic,strong)NSString *feng;//	峰电价
@property (nonatomic,strong)NSString *ping;//	平电价
@property (nonatomic,strong)NSString *gu;//	谷电价
@property (nonatomic,strong)NSString *feeJ;//	尖服务费
@property (nonatomic,strong)NSString *feeF;//	峰服务费
@property (nonatomic,strong)NSString *feeP;//	平服务费
@property (nonatomic,strong)NSString *feeG;//	谷服务费

/**
 * 存储的数据
 */
@property (nonatomic,strong)NSDictionary *storedDict;
- (void)getDistanceWithLocation:(CLLocationCoordinate2D )location;
- (id)initWithDict:(NSDictionary *)dict;
@end
