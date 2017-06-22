//
//  SBHHttp.h
//  chargingPile
//
//  Created by chargingPile on 14-12-5.
//  Copyright (c) 2014年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef  void(^ResponseBlock)(id responseObj);
@interface CPHttp : NSObject
+ (CPHttp *)sharedInstance;
//get请求
- (void)getPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;
//post请求
- (void)postPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;

// 下载文件
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress;
@end
