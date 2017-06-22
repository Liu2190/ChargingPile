//
//  CPPublishEvalutionViewController.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"
#import "CPPileEvalutionModel.h"
#import "CPPlieModel.h"

typedef NS_ENUM(NSInteger,CPPublishEvalutionViewControllerSourceType) {
    CPPublishEvalutionViewControllerTypeComment,
    CPPublishEvalutionViewControllerTypeReply,
};
@interface CPPublishEvalutionViewController : CPBaseTableViewController
@property (nonatomic,assign)CPPublishEvalutionViewControllerSourceType sourceType;
@property (nonatomic,strong)CPPileEvalutionModel *commentModel;
@property (nonatomic,strong)CPPlieModel *pileModel;

@end
