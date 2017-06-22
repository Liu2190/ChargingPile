//
//  AppDelegate.h
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabbarViewController.h"
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CPTabbarViewController *tabbarController;
@property (nonatomic,strong) CLLocationManager *manager;
/**
 * 获取到的经纬度
 */
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
/**
 * 充值金额
 */
@property (strong, nonatomic) NSString *chargePriceString;
//获取当前显示的ViewController
- (UIViewController *)getCurrentDisplayViewController;
+ (AppDelegate *)appdelegate;

@end

