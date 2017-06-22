//
//  CPPileEvalutionTitleFrame.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPPileEvalutionModel.h"

#define kPileEvalutionLeftSpace 75.0

@interface CPPileEvalutionTitleFrame : NSObject
@property (nonatomic,assign,readonly)CGRect headerFrame;
@property (nonatomic,assign,readonly)CGRect nameFrame;
@property (nonatomic,assign,readonly)CGRect scoreFrame;
@property (nonatomic,assign,readonly)CGRect timeFrame;
@property (nonatomic,assign,readonly)CGRect evalutionFrame;
@property (nonatomic,assign,readonly)CGRect deleteFrame;
@property (nonatomic,assign,readonly)CGRect thumbUpFrame;
@property (nonatomic,assign,readonly)CGRect commentFrame;
@property (nonatomic,assign,readonly)CGFloat cellHeight;
@property (nonatomic,strong)CPPileEvalutionModel *listModel;
@end
