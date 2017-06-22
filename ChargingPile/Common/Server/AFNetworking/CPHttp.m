 //
//  SBHHttp.m
//  chargingPile
//
//  Created by chargingPile on 14-12-5.
//  Copyright (c) 2014年 chargingPile. All rights reserved.
//

#import "CPHttp.h"
#import "BeGlobalConfigure.h"
#import "CommonDefine.h"
#import "NSDictionary+Additions.h"
#import "MBProgressHUD+MJ.h"
#import "CMPAccount.h"

@implementation CPHttp
+ (CPHttp *)sharedInstance
{
    static dispatch_once_t onceToken;
    static CPHttp *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[CPHttp alloc]init];
    });
    return _instance;
}

- (void)getPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;
{
    if(![self checkNetWork])
    {
        NSError *err = [NSError errorWithDomain:@"no network available" code:kErrCodeNetWorkUnavaible userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"no network available",NSLocalizedDescriptionKey, nil]];
        failure (err);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"charset=utf-8",@"text/html",@"application/json",nil];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:parmrs];
    [manager GET:urlStr parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation isCancelled])
        {
            NSError *error = [NSError errorWithDomain:@"" code:kHttpRequestCancelledError userInfo:nil];
            failure(error);
            return;
        }
        failure(error);
    }];
}

- (void)postPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs success:(ResponseBlock)success failure:(void (^)(NSError *error))failure
{
    if(![self checkNetWork])
    {
        NSError *err = [NSError errorWithDomain:@"no network available" code:kErrCodeNetWorkUnavaible userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"no network available",NSLocalizedDescriptionKey, nil]];
        failure (err);
        return;
    }
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
   // mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/javascript",@"application/json",@"text/html",@"text/plain", nil];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:parmrs];
    [mgr POST:urlStr parameters:paraDict
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          success (responseObject);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD hideHUD];
          if([operation isCancelled])
          {
              NSError *error = [NSError errorWithDomain:@"" code:kHttpRequestCancelledError userInfo:nil];
              failure(error);
              return;
          }
          failure(error);
      }];
}
- (void)showNoNetworkAlert
{

}
- (BOOL)checkNetWork
{
    if([[BeGlobalConfigure sharedInstance]isNetWorkAvailable]==NO)
    {
        [self performSelectorOnMainThread:@selector(showNoNetworkAlert) withObject:nil waitUntilDone:NO modes:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSError*)formatError:(NSDictionary*)responseObject atPath:(NSString*)path
{
    return [NSError errorWithDomain:path
                               code:[responseObject intValueForKey:@"code"]
                           userInfo:responseObject];
}


/** 文件下载 */
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress
{
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"Get" URLString:requestURL parameters:paramDic error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
        NSLog(@"下载失败");
    }];
    [operation start];
}
@end
