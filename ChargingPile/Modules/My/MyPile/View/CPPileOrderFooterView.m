//
//  CPPileOrderFooterView.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/12/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileOrderFooterView.h"

@implementation CPPileOrderFooterView

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
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.3)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        for(int i = 0;i < 2;i++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2.0 * i + frame.size.width/(2.0 * 5.0), line.height, frame.size.width/2.0  - frame.size.width/(2.0 * 5.0), frame.size.height - line.height - 5)];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:15];
            if(i == 0)
            {
                self.totalAmountLabel = label;
                self.totalAmountLabel.text = @"总金额：";
            }
            else
            {
                self.totalElectricQuantityLabel = label;
                self.totalElectricQuantityLabel.text = @"总电量：";
            }
            [self addSubview:label];
        }
    }
    return self;
}
@end
