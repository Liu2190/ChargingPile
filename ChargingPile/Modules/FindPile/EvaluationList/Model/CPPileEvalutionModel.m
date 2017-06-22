//
//  CPPileEvalutionModel.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvalutionModel.h"
#import "NSDictionary+Additions.h"

@implementation CPPileEvalutionModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _thumbupArray = [[NSMutableArray alloc]init];
        _replyArray = [[NSMutableArray alloc]init];
        _thumbupEvalutionIdArray = [[NSMutableArray alloc]init];
        _thumbupUserIdArray = [[NSMutableArray alloc]init];
        
        _commentId = [dict stringValueForKey:@"commentId"];
        _content = [dict stringValueForKey:@"content"];
        _createTime = [dict stringValueForKey:@"createTime"];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY.MM.dd"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_createTime doubleValue]/1000];
        _displayTime = [formatter stringFromDate:confromTimesp];
        _evalutionId = [dict stringValueForKey:@"id"];
        _isReply = [dict stringValueForKey:@"isReply"];
        _reply = [dict arrayValueForKey:@"reply"];
        _stationName = [dict stringValueForKey:@"stationName"];
        _stationStar = [dict stringValueForKey:@"stationStar"];
        _types = [dict stringValueForKey:@"types"];
        _userId = [dict stringValueForKey:@"userId"];
        _userName = [dict stringValueForKey:@"userName"];
        if(_reply != nil)
        {
            for(NSDictionary *replyDict in _reply)
            {
                CPPileEvalutionModel *model = [[CPPileEvalutionModel alloc]initWithDict:replyDict];
                if([model.isReply intValue] == 1 && [model.content length] > 0)
                {
                    //回复
                    [_replyArray addObject:model];
                }
                if([model.isReply intValue] == 1 && [model.content length] == 0)
                {
                    //赞
                    [_thumbupArray addObject:model];
                }
            }
        }
    }
    return self;
}
- (void)deleteRepeatThumbup
{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    [_thumbupEvalutionIdArray removeAllObjects];
    for(CPPileEvalutionModel *thumbupModel in _thumbupArray)
    {
        [_thumbupEvalutionIdArray addObject:thumbupModel.evalutionId];
        [_thumbupUserIdArray addObject:thumbupModel.userId];
        if(![tempArray containsObject:thumbupModel.userId])
        {
            [tempArray addObject:thumbupModel.userId];
        }
        else
        {
            [set addIndex:[_thumbupArray indexOfObject:thumbupModel]];
        }
    }
    if(set.count > 0)
    {
        [_thumbupArray removeObjectsAtIndexes:set];
    }
}
@end
