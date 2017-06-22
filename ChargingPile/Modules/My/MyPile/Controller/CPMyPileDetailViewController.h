//
//  CPMyPileDetailViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPMyPileDetailModel.h"
typedef void (^CPMyPileDetailViewControllerBlock)(void);

typedef NS_ENUM(NSInteger,CPMyPileDetailVCSourceType) {
    CPMyPileDetailVCSourceTypeCreate,
    CPMyPileDetailVCSourceTypeEdit,
};
@interface CPMyPileDetailViewController : CPBaseTableViewController
@property (nonatomic,assign)CPMyPileDetailVCSourceType sourceType;
@property (nonatomic,strong)NSString *pileId;
@property (nonatomic,copy)CPMyPileDetailViewControllerBlock block;
@end
