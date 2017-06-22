//
//  CPPileEvalutionListViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPPileEvalutionModel.h"
#import "CPPlieModel.h"

@interface CPPileEvalutionListViewController : CPBaseTableViewController
@property (nonatomic,strong)CPPlieModel *pileModel;
@property (nonatomic,assign)CPPileEvalutionModelType sourceType;
@end
