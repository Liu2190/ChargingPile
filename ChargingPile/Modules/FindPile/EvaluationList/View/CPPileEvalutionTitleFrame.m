//
//  CPPileEvalutionTitleFrame.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvalutionTitleFrame.h"
#import "CMPAccount.h"

@implementation CPPileEvalutionTitleFrame
- (void)setListModel:(CPPileEvalutionModel *)listModel
{
    _listModel = listModel;
    _headerFrame = CGRectMake(16, 16, 50, 50);
    _timeFrame = CGRectMake(kScreenW - 85, 16, 75, 20);

    float titleX = 75;
    float titleY = 16;
    float titleWidth = _timeFrame.origin.x - titleX - 5;
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kOrderListCellFont;
    CGRect nameRect = [listModel.userName boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _nameFrame = CGRectMake(titleX, titleY, titleWidth, nameRect.size.height + 2);
    if(_listModel.type == CPPileEvalutionModelTypeMy)
    {
        _scoreFrame = CGRectMake(titleX, CGRectGetMaxY(_nameFrame) + 10, 80, 15);
    }
    else
    {
        _scoreFrame = CGRectMake(titleX, CGRectGetMaxY(_nameFrame) + 10, 80, 0);
    }

    float evalutionWidth = kScreenW - 15 - titleX;
    attribute[NSFontAttributeName] = kContentSmallCellFont;
    nameRect = [[NSString stringWithFormat:@"%@\n",listModel.content] boundingRectWithSize:CGSizeMake(evalutionWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _evalutionFrame = CGRectMake(titleX, CGRectGetMaxY(_scoreFrame), evalutionWidth, nameRect.size.height );
    
    CGRect originalDeleteFrame = CGRectMake(titleX, CGRectGetMaxY(_evalutionFrame) + 5, 30, 20);

    if([[CMPAccount sharedInstance].accountInfo.uid intValue] != [_listModel.userId intValue])
    {
        _deleteFrame = CGRectZero;
    }
    else
    {
        _deleteFrame = originalDeleteFrame;
    }
    _thumbUpFrame = CGRectMake(kScreenW - 15 - 110 - 5, originalDeleteFrame.origin.y, 55, 20);
    _commentFrame = CGRectMake(kScreenW - 15 - 55, originalDeleteFrame.origin.y, 55, 20);
    _cellHeight = CGRectGetMaxY(_commentFrame) + 10.0f;
}
@end
