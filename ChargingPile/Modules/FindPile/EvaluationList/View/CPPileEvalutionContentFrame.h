//
//  CPPileEvalutionContentFrame.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPPileEvalutionModel.h"
#define kLineSpacing 8

@interface CPPileEvalutionContentFrame : NSObject
@property (nonatomic,strong)CPPileEvalutionModel *replyModel;
@property (nonatomic,assign,readonly)CGRect replyFrame;
@property (nonatomic,assign,readonly)CGRect bgFrame;
@property (nonatomic,assign,readonly)CGRect headerFrame;
@property (nonatomic,assign,readonly)CGRect thumbUpFrame;
@property (nonatomic,assign,readonly)float cellHeight;
@end
