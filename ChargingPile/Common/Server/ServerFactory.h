//
//  ServerFactory.h
//  RobinLiu
//
//  Created by RobinLiu on 14-10-10.
//  Copyright (c) 2014年 RobinLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerFactory : NSObject{
    NSMutableDictionary *_serverDicts;
}
+ (id)getServerInstance:(NSString *)serverName;
@end
