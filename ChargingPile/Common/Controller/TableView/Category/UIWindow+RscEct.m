//
//  UIWindow+RscEct.m
//  WePilot
//
//  Created by chargingPile on 14/12/17.
//  Copyright (c) 2014年 wedoauto. All rights reserved.
//

#import "UIWindow+RscEct.h"

@implementation UIWindow (RscEct)
- (UIView *)findFirstResponder
{
    return [self findFirstResponderInView:self];
}
- (UIView *)findFirstResponderInView:(UIView *)topView
{
    if([topView isFirstResponder])
    {
        return topView;
    }
    for(UIView *subView in [topView subviews])
    {
        if([subView isFirstResponder])
        {
            return subView;
        }
        UIView *firstResponderCheck = [self findFirstResponderInView:subView];
        if(nil != firstResponderCheck)
        {
            return firstResponderCheck;
        }
    }
    return nil;
}
@end
