//
//  CPDynamicListModel.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDynamicListModel : NSObject
@property (nonatomic,strong)NSString *dynamicId;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *subTitle;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)UIImage *image;
- (id)initWith:(NSDictionary *)dict;
@end
