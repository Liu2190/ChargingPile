//
//  CPEditInfoViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
typedef NS_ENUM(NSInteger,EditInfoVCSourceType) {
    EditInfoVCSourceTypeName = 0,
    EditInfoVCSourceTypeGender = 1,
    EditInfoVCSourceTypeIdCard = 2,
    EditInfoVCSourceTypeQQ = 3,
    EditInfoVCSourceTypeAddress = 4,
};
@interface CPEditInfoViewController : CPBaseTableViewController
@property (nonatomic,assign)EditInfoVCSourceType sourceType;
@end
