//
//  CPSetPasswordViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPResetPasswordViewController.h"

@interface CPSetPasswordViewController : CPBaseTableViewController
@property (nonatomic,assign)CPRegisterViewControllerType sourceType;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *code;
@end
