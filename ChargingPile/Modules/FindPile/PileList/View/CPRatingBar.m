//
//  CPRatingBar.m
//  ChargingPile
//
//  Created by RobinLiu on 16/10/4.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPRatingBar.h"

#define kFullStarImageName @"全星"
#define kGrayStarImageName @"灰"
#define kSpace 3.0f
@implementation CPRatingBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setRateValue:(float)rateValue
{
    _rateValue = rateValue;
    CGFloat imageX = 0;
    int count = _rateValue/1;
    float value = _rateValue - count;
    if(count > 0)
    {
        //全黄
        for(int i = 0;i < count;i++)
        {
            UIImageView *fullImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kFullStarImageName]];
            fullImageView.centerY = self.height/2.0;
            fullImageView.x = imageX;
            [self addSubview:fullImageView];
            imageX = imageX + fullImageView.size.width + kSpace;
        }
    }
    if(value > 0)
    {
        //半灰半黄
        UIImageView *darkgrayImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kGrayStarImageName]];
        [self addSubview:darkgrayImageView];
        darkgrayImageView.centerY = self.height/2.0;
        darkgrayImageView.x = imageX;
        UIImageView *fullImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kFullStarImageName]];
        [self addSubview:fullImageView];
        fullImageView.centerY = self.height/2.0;
        fullImageView.x = imageX;
        fullImageView.layer.contentsRect = CGRectMake(0, 0, value, 1);
        fullImageView.clipsToBounds = YES;
        fullImageView.contentMode = UIViewContentModeBottomLeft;
        imageX = imageX + fullImageView.size.width + kSpace;
    }
    if((value > 0 && count < 4) || (value == 0 && count < 5))
    {
        int max = 0;
        if(value > 0 && count < 4)
        {
            max = 5 - count - 1;
        }
        else
        {
            max = 5 - count;
        }
        //全灰
        for(int i = 0;i < max;i++)
        {
            UIImageView *fullImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kGrayStarImageName]];
            fullImageView.centerY = self.height/2.0;
            fullImageView.x = imageX;
            [self addSubview:fullImageView];
            imageX = imageX + fullImageView.size.width + kSpace;
        }
    }
}
@end
