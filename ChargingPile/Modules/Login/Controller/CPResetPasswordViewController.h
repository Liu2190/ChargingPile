//
//  CPRegisterViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
typedef NS_ENUM(NSInteger,CPRegisterViewControllerType) {
    CPRegisterVCTypeRegister = 0,//注册
    CPRegisterVCTypePassword = 1,//重置密码
};

@interface CPResetPasswordViewController : CPBaseTableViewController
@property (nonatomic,assign)CPRegisterViewControllerType sourceType;
@end
