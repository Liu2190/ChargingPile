//
//  CPPileEvaHeaderFrame.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvaHeaderFrame.h"

#define kViewTopVerticalMarginal        16
#define kViewBottomVerticalMarginal     15
#define kViewLeftHorizontalMarginal     15
#define kTitleSpaceMarginal             12

@implementation CPPileEvaHeaderFrame

- (void)setListModel:(CPPlieModel *)listModel
{
    _listModel = listModel;
    
    //cell的宽度
    CGFloat cellW = kScreenW;
    float titleX = kViewLeftHorizontalMarginal;
    float titleY = kViewTopVerticalMarginal;
    float titleW = cellW - 2.0 * titleX;
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kOrderListCellFont;
    CGRect nameRect = [listModel.name boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    /**
     *  名称
     */
    _pileNameFrame = CGRectMake(titleX, titleY, titleW, nameRect.size.height);
    
    /**
     * 公共站
     */
    _tip1Frame = CGRectMake(titleX, CGRectGetMaxY(_pileNameFrame) + kTitleSpaceMarginal, 43, 16);
    
    /**
     * 有空闲
     */
    _tip2Frame = CGRectMake(CGRectGetMaxX(_tip1Frame) + 6, _tip1Frame.origin.y, _tip1Frame.size.width, _tip1Frame.size.height);

    /**
     * 评分
     */
    _scoreFrame = CGRectMake(cellW - 80 - kViewLeftHorizontalMarginal, _tip1Frame.origin.y, 80, _tip1Frame.size.height);
    
    attribute[NSFontAttributeName] = kContentSmallCellFont;
    CGRect disFrame = [listModel.distanceAppearance boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    /**
     * 距离
     */
    _distanceFrame = CGRectMake(cellW - disFrame.size.width - kViewLeftHorizontalMarginal, CGRectGetMaxY(_tip1Frame) + kTitleSpaceMarginal, disFrame.size.width, disFrame.size.height);
    
    /**
     * 地址
     */
    float addressWidth = _distanceFrame.origin.x - kViewLeftHorizontalMarginal * 2.0;
    CGRect aFrame = [[NSString stringWithFormat:@"地址：%@",listModel.address] boundingRectWithSize:CGSizeMake(addressWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _addressFrame = CGRectMake(kViewLeftHorizontalMarginal, _distanceFrame.origin.y, addressWidth, aFrame.size.height);
    
    _cellHeight = CGRectGetMaxY(_addressFrame) + kViewBottomVerticalMarginal;
}
@end
