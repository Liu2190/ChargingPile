//
//  CPOrderListFrame.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPOrderListFrame.h"
#import "CommonDefine.h"

#define kViewHorizontalMarginal 17
#define kViewVerticalMarginal 17
#define kTitleHorizontalMarginal 20
#define kTitleVerticalMarginal 17

@implementation CPOrderListFrame
- (void)setListModel:(CPOrderListModel *)listModel
{
    _listModel = listModel;
    
    //cell的宽度
    CGFloat cellW = kScreenW;
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kOrderListCellFont;

    /**
     *  时间图片
     */
    CGFloat titleX = kViewHorizontalMarginal * 2.0;
    CGFloat timeImageY = kViewVerticalMarginal * 2.0f;
    _timeImageViewframe = CGRectMake(titleX, timeImageY, 20, 20);
    
    /**
     *  时间
     */
    CGFloat timeLabelX = CGRectGetMaxX(_timeImageViewframe) + kViewHorizontalMarginal;
    CGRect sumRect = [listModel.displayTime boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _timeLabelframe = CGRectMake(timeLabelX, _timeImageViewframe.origin.y, sumRect.size.width, _timeImageViewframe.size.height);
    
    /**
     *  状态
     */
    sumRect = [listModel.orderStatus boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat statusLabelX = cellW - sumRect.size.width - kViewHorizontalMarginal * 2.0;
    _statusLabelframe = CGRectMake(statusLabelX, _timeImageViewframe.origin.y, sumRect.size.width, _timeImageViewframe.size.height);
    
    /**
     *  分割线
     */
    _sepLineframe = CGRectMake(titleX, CGRectGetMaxY(_statusLabelframe) + kViewVerticalMarginal, kScreenW - titleX * 2.0, 1);
    
    /**
     *  订单号
     */
    sumRect = [@"充电价格" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _orderNumberframe = CGRectMake(titleX, CGRectGetMaxY(_sepLineframe) + kTitleVerticalMarginal, sumRect.size.width, sumRect.size.height);
    
    CGFloat cellContentWidth = cellW - CGRectGetMaxX(_orderNumberframe) -  kViewHorizontalMarginal * 2.0;
    CGFloat cellContentX =  CGRectGetMaxX(_orderNumberframe);
    sumRect = [listModel.orderNo boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _orderNumberContentframe = CGRectMake(CGRectGetMaxX(_statusLabelframe) - sumRect.size.width, _orderNumberframe.origin.y, sumRect.size.width, sumRect.size.height);

    /**
     *  电桩名称
     */
    
    _orderNameframe = CGRectMake(titleX, CGRectGetMaxY(_orderNumberContentframe) + kTitleVerticalMarginal, _orderNumberframe.size.width, _orderNumberframe.size.height);
    sumRect = [listModel.pileName boundingRectWithSize:CGSizeMake(cellContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _orderNameContentframe = CGRectMake(CGRectGetMaxX(_statusLabelframe) - sumRect.size.width, _orderNameframe.origin.y, sumRect.size.width, sumRect.size.height);
    //位置
    _orderAddressframe = CGRectMake(titleX, CGRectGetMaxY(_orderNameContentframe) + kTitleVerticalMarginal, _orderNumberframe.size.width, _orderNumberframe.size.height);
    sumRect = [listModel.address boundingRectWithSize:CGSizeMake(cellContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _orderAddressContentframe = CGRectMake(CGRectGetMaxX(_statusLabelframe) - sumRect.size.width, _orderAddressframe.origin.y, sumRect.size.width, sumRect.size.height);
    //消费金额
    _orderPriceframe = CGRectMake(titleX, CGRectGetMaxY(_orderAddressContentframe) + kTitleVerticalMarginal, _orderNumberframe.size.width, _orderNumberframe.size.height);
    sumRect = [listModel.amount boundingRectWithSize:CGSizeMake(cellContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _orderPriceContentframe = CGRectMake(CGRectGetMaxX(_statusLabelframe) - sumRect.size.width, _orderPriceframe.origin.y, sumRect.size.width, sumRect.size.height);
    
    //充电电量
    _orderIncomeframe = CGRectMake(titleX, CGRectGetMaxY(_orderPriceContentframe) + kTitleVerticalMarginal, _orderNumberframe.size.width, _orderNumberframe.size.height);
    sumRect = [listModel.qty boundingRectWithSize:CGSizeMake(cellContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _orderIncomeContentframe = CGRectMake(CGRectGetMaxX(_statusLabelframe) - sumRect.size.width, _orderIncomeframe.origin.y, sumRect.size.width, sumRect.size.height);
    if(_listModel.type == OrderListModelTypeUser)
    {
    }
    else
    {
        _orderTipLabelframe = CGRectZero;
    }
    
    CGFloat maxY = CGRectGetMaxY(_orderIncomeContentframe) + kTitleVerticalMarginal;
    if(_listModel.type == OrderListModelTypePileOwnerWJS)
    {
        _orderTipLabelframe = CGRectMake(titleX, maxY, 200, CGRectGetHeight(_orderNameframe));
        maxY = CGRectGetMaxX(_orderTipLabelframe) + kTitleVerticalMarginal;
    }
    else
    {
        _orderTipLabelframe = CGRectZero;
    }
    
    _bgViewframe = CGRectMake(kViewHorizontalMarginal, kViewVerticalMarginal, cellW - kViewHorizontalMarginal * 2.0, maxY);
    _cellHeight = CGRectGetMaxY(_bgViewframe) + 2;
}
@end
