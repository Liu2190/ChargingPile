//
//  CPPileListHeaderView.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileListHeaderView.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

@implementation CPPileListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        NSArray *titleArray = @[@"距离",@"排序",@"筛选"];
        UIImage *ig1 = [UIImage imageNamed:@"pull_normal"];
        for(int i = 0;i< titleArray.count;i++)
        {
            UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tempButton.frame = CGRectMake(kScreenW/3.0 * i, 0, kScreenW/3.0, frame.size.height);
            [tempButton setTitle:titleArray[i] forState:UIControlStateNormal];
            tempButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [tempButton layoutIfNeeded];
            [tempButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [tempButton addTarget:self action:@selector(changeQy) forControlEvents:UIControlEventTouchUpInside];
            [tempButton setImage:ig1 forState:UIControlStateNormal];
            [tempButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            [tempButton setImageEdgeInsets:UIEdgeInsetsMake(0, tempButton.titleLabel.bounds.size.width+10,0, -tempButton.titleLabel.bounds.size.width-10)];
            [self addSubview:tempButton];
            tempButton.tag = i;
        }
    }
    return self;
}
- (void)changeQy
{
    
}
@end
