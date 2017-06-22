//
//  CPPileAnnotationView.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

#define kCPPileAnnotationViewNotification @"CPPileAnnotationNotification"
#define kCPPileAnnotationViewSelectNotification @"CPPileAnnotationSelectNotification"

@interface CPPileAnnotationView : MAAnnotationView
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)UIView *calloutView;
@end

