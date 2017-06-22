//
//  CPPileEvalutionContentFrame.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvalutionContentFrame.h"

@implementation CPPileEvalutionContentFrame
- (void)setReplyModel:(CPPileEvalutionModel *)replyModel
{
    _replyModel = replyModel;
    CGFloat titleWidth = kScreenW - 85 - 22;

    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kOrderListCellFont;
    
    NSString *thumbupString = @"";
    if(replyModel.thumbupArray.count > 0)
    {
        thumbupString = @"♡  ";
    }
    for(int i = 0;i < replyModel.thumbupArray.count;i++)
    {
        CPPileEvalutionModel *reply = replyModel.thumbupArray[i];
        
        thumbupString = [thumbupString stringByAppendingString:reply.userName];
        if(i != replyModel.thumbupArray.count - 1)
        {
            thumbupString = [thumbupString stringByAppendingString:@"，"];
        }
    }
    CGRect nameRect = [thumbupString boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    float thumbUpFrameY = thumbupString.length > 0?8:1;
    _thumbUpFrame = CGRectMake(85, thumbUpFrameY, titleWidth, nameRect.size.height);
    NSString *contentString = @"";
    for(int i = 0;i < replyModel.replyArray.count;i++)
    {
        CPPileEvalutionModel *model = replyModel.replyArray[i];
        contentString = [contentString stringByAppendingString:[NSString stringWithFormat:@"%@：%@",model.userName,model.content]];
        if(i != replyModel.replyArray.count -1)
        {
            contentString = [contentString stringByAppendingString:@"\n"];
        }
    }
    _headerFrame = CGRectZero;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpacing];
    attribute[NSParagraphStyleAttributeName] = paragraphStyle;
    nameRect = [contentString boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat space = contentString.length > 0?4:0;
    if(thumbupString.length > 0 && contentString.length)
    {
        space = 10;
    }
    _replyFrame = CGRectMake(85,CGRectGetMaxY(_thumbUpFrame) + space, titleWidth, nameRect.size.height);
    _bgFrame = CGRectMake(75, 0, kScreenW - 75 - 15, CGRectGetMaxY(_replyFrame) + 5);
    _cellHeight = CGRectGetMaxY(_bgFrame);
}
@end
