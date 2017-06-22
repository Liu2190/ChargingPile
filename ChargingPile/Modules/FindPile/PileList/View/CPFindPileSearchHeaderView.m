//
//  CPFindPileSearchHeaderView.m
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/10.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import "CPFindPileSearchHeaderView.h"

@implementation CPFindPileSearchHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _titleLbael = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, frame.size.height)];
        _titleLbael.textColor = [UIColor darkGrayColor];
        _titleLbael.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLbael];
        
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(frame.size.width - 120, 0,100, frame.size.height);
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_clearButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:_clearButton];
    }
    return self;
}
@end
