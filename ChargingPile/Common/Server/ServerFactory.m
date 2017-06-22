//
//  ServerFactory.m
//  RobinLiu
//
//  Created by RobinLiu on 14-10-10.
//  Copyright (c) 2014年 RobinLiu. All rights reserved.
//

#import "ServerFactory.h"

static ServerFactory *sharedInstance = nil;

@implementation ServerFactory
- (id)init
{
    self = [super init];
    _serverDicts = [[NSMutableDictionary alloc]init];
    return self;
}
+ (id)getServerInstance:(NSString *)serverName
{
    @synchronized(self){// 避免多线程并发创建多个实例
        if(sharedInstance == nil)
        {
            sharedInstance = [[ServerFactory alloc]init];
        }
    }
    id theServer = [sharedInstance getServer:serverName];
    if(theServer == nil)
    {
        theServer = [sharedInstance addServer:serverName];
    }
    return theServer;
}
- (id)getServer:(NSString *)serverName{
    id theServer = [_serverDicts objectForKey:serverName];
    return theServer;
}
- (id)addServer:(NSString *)serverName
{
    Class controllerClass = NSClassFromString(serverName);
    id theServer = [[controllerClass alloc]init];
    if(theServer == nil)
    {
        return nil;
    }
    [_serverDicts setObject:theServer forKey:serverName];
    return theServer;
}
@end
