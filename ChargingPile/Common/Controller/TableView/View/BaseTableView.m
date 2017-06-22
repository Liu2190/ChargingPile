//
//  BaseTableView.m
//  WePilot
//
//  Created by chargingPile on 14/12/16.
//  Copyright (c) 2014年 wedoauto. All rights reserved.
//

#import "BaseTableView.h"
#import "UIWindow+RscEct.h"

@implementation BaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)reloadData {
    // -[UITableView reloadData] takes away first responder status if the first responder is a
    // subview, so remember it and then restore it afterward to avoid awkward keyboard disappearance
    UIResponder* firstResponder = [self.window findFirstResponderInView:self];
    
    [super reloadData];
    
    if (nil != firstResponder) {
        [firstResponder becomeFirstResponder];
    }
}

@end
