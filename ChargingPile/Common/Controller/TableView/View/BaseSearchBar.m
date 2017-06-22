//
//  BaseSearchBar.m
//  WePilot
//
//  Created by chargingPile on 14/12/17.
//  Copyright (c) 2014年 wedoauto. All rights reserved.
//

#import "BaseSearchBar.h"

@implementation BaseSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super init];
    if(self)
    {
        self.placeholder = NSLocalizedString(@"搜索", nil);
    }
    return self;
}
@end
