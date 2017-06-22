//
//  CPPileAnnotation.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "CPPlieModel.h"
@interface CPPileAnnotation : NSObject<MAAnnotation>
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)CPPlieModel *pileModel;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *subtitle;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
