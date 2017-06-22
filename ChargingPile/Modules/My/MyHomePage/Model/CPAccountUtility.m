//
//  CPAccountUtility.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPAccountUtility.h"
#import "CMPAccount.h"
#import "ServerAPI.h"
#import <MobileCoreServices/UTType.h>
#import "SDImageCache.h"

#define kHeaderIconPath [NSHomeDirectory() stringByAppendingString:@"/Documents/AccountHeader"]
@implementation CPAccountUtility
{
    NSMutableURLRequest *request;
    NSOperationQueue *queue;
    NSURLConnection *_connection;
    NSMutableData *_reveivedData;
}
static CPAccountUtility *instance = nil;
+(CPAccountUtility*)getSharedInstance
{
    if(instance ==nil){
        @synchronized (self)
        {
            if(!instance)
            {
                instance = [[CPAccountUtility alloc] init];
            }
        }
    }
    return instance;
}
- (void)updateUserInfoWith:(NSDictionary *)userInfo andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    if(![[params allKeys] containsObject:@"id"])
    {
        params[@"id"] = [NSString stringWithFormat:@"%@",[CMPAccount sharedInstance].accountInfo.uid];
    }
    [self uploadUserInfoAndImageWith:nil andParams:params withSuccessCallback:^(NSDictionary *dict)
     {
         if([[dict stringValueForKey:@"state"] intValue] == 0)
         {
             //上传成功
             callback(@"修改成功");
         }
         else
         {
             failure(@"修改失败");
         }
     }andFailureCallback:^(NSError *error)
     {
         failure(@"修改失败");
     }];
}
- (void)startUploadUserHeaderIconWith:(NSData *)imageData withSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    [self uploadUserInfoAndImageWith:imageData andParams:@{@"id":[NSString stringWithFormat:@"%@",[CMPAccount sharedInstance].accountInfo.uid]} withSuccessCallback:^(NSDictionary *dict)
     {
         if([[dict stringValueForKey:@"state"] intValue] == 0)
         {
             //上传成功
             [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid]];
             NSFileHandle *fh = [NSFileHandle fileHandleForUpdatingAtPath:kHeaderIconPath];
             [fh writeData:imageData];
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUploadHeaderSuccess object:nil];
             callback(@"修改成功");
         }
         else
         {
             failure(@"修改失败");
         }
     }andFailureCallback:^(NSError *error)
     {
         failure(@"修改失败");
     }];
}
- (void)uploadUserInfoAndImageWith:(NSData *)imageData andParams:(NSDictionary *)params withSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/update"];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"charset=utf-8", nil];
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if(params!=nil)
         {
             for (NSString *key in params) {
                 id value = [params objectForKey:key];
                 [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
             }
         }
         if(imageData != nil)
         {
             [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"file.png" mimeType:@"image/png"];
         }
     } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         callback([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}
@end
