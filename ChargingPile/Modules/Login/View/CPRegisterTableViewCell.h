//
//  CPRegisterTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRegisterTableViewCell : UITableViewCell
@property (nonatomic,strong)UITextField *tf;
@property (nonatomic,strong)UIButton *codeButton;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
