//
//  CPMyPileOrderHeaderView.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/10.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileOrderHeaderView.h"
#import "ColorConfigure.h"

@interface CPMyPileOrderHeaderView()
{
    UIButton *button1,*button2;
    UIView *tipView;
    
    id privateTarget;
    SEL action1,action2;
}
@end
@implementation CPMyPileOrderHeaderView

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
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titleArray = @[@"未结算",@"已结算"];
        CGFloat sepLineWith = .5f;
        CGFloat buttonWidth = kScreenW/2.0 - sepLineWith;
        CGFloat tipViewHeight = 2.0f;
        CGFloat buttonHeight = kCPMyPileOrderHeaderViewHeight - tipViewHeight;
        CGFloat sepLineHeight = buttonHeight - 10.0f;

        for(int i = 0;i < titleArray.count;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((buttonWidth + sepLineWith) * i, 0, buttonWidth, buttonHeight);
            button.tag = i;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if(i == 0)
            {
                button1 = button;
                [button1 setTitleColor:[ColorConfigure globalGreenColor] forState:UIControlStateNormal];
            }
            else
            {
                button2 = button;
                [button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        }
        UIView *sepView= [[UIView alloc]initWithFrame: CGRectMake(buttonWidth + sepLineWith/2.0, 0, sepLineWith, sepLineHeight)];
        sepView.centerY = buttonHeight/2.0;
        sepView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sepView];
        
        tipView = [[UIView alloc]initWithFrame: CGRectMake(0, kCPMyPileOrderHeaderViewHeight - tipViewHeight, kScreenW/2.0, tipViewHeight)];
        tipView.backgroundColor = [ColorConfigure globalGreenColor];
        [self addSubview:tipView];
    }
    return self;
}
- (void)buttonAction:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [privateTarget performSelector:action1 withObject:[NSNumber numberWithInt:OrderListModelTypePileOwnerWJS] afterDelay:0.001];
        [self setLineAnimationWithPosition:OrderListModelTypePileOwnerWJS];
    }
    else
    {
        [privateTarget performSelector:action1 withObject:[NSNumber numberWithInt:OrderListModelTypePileOwnerYJS]  afterDelay:0.001];
        [self setLineAnimationWithPosition:OrderListModelTypePileOwnerYJS];
    }
}
- (void)addTarget:(id)target andWJS:(SEL)wjsAction andYJS:(SEL)yjsAction
{
    privateTarget = target;
    action1 = wjsAction;
    action2 = yjsAction;
}
- (void)setType:(OrderListModelType)type
{
    if(_type == type)
    {
        return;
    }
    _type = type;
    if(type == OrderListModelTypePileOwnerWJS)
    {
        tipView.x = 0;
        [button1 setTitleColor:[ColorConfigure globalGreenColor] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        tipView.x = kScreenW/2.0;
        [button2 setTitleColor:[ColorConfigure globalGreenColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}
- (void)setLineAnimationWithPosition:(OrderListModelType)type
{
    [UIView beginAnimations:@"TransitionAnimation" context:NULL];
    [UIView setAnimationDuration:.15];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self setType:type];
    [UIView commitAnimations];
}
@end
