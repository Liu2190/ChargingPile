//
//  CMPAccount.m
//  chargingPile
//
//  Created by RobinLiu on 15/9/8.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "CMPAccount.h"

static CMPAccount *sharedAcount = nil;
@implementation CMPAccount
- (id)init
{
    if(self = [super init])
    {
        self.accountInfo = [[CMPAccountInfo alloc]init];
    }
    return self;
}
+ (CMPAccount *)sharedInstance
{
    if(!sharedAcount)
    {
        @synchronized (self)
        {
            if(!sharedAcount)
            {
                sharedAcount = [[CMPAccount alloc]init];
                [sharedAcount.accountInfo initConfigure];
            }
        }
    }
    return sharedAcount;
}
@end
