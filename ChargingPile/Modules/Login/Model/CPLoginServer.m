//
//  CPLoginServer.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPLoginServer.h"
#import "CPHttp.h"
#import "ServerAPI.h"
#import "NSString+sha256.h"
#import "CMPAccount.h"

@implementation CPLoginServer
/**
 * 获取短信验证码
 */
- (void)doGetSMSVerificationCodeWith:(NSString *)phone andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/code"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"phone"] = phone;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
    {
        NSLog(@"成功 = %@",responseObj);
    }failure:^(NSError *error)
    {
        NSLog(@"失败 = %@",error);
    }];
}
/**
 * 校验短信验证码
 */
- (void)doCheckSMSVerificationCodeWith:(NSString *)phone andCode:(NSString *)code andSuccess:(void (^)(id))callback andFailure:(void (^)(id ))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/verify"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"phone"] = phone;
    parameter[@"code"] = code;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         NSLog(@"校验短信验证码成功 = %@",responseObj);
         callback(responseObj);
     }failure:^(NSError *error)
     {
         NSLog(@"校验短信验证码失败 = %@",error);
         failure(error);
     }];
}
/**
 * 用户注册
 */
- (void)doRegisterWithUsername:(NSString *)username andName:(NSString *)name andPassword:(NSString *)password andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/signin"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"username"] = username;
    parameter[@"name"] = name;
    parameter[@"password"] = [password sha256];

   // parameter[@"password"] = [password sha256];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
- (void)checkPhoneIsRegisteredWithUserName:(NSString *)userName andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    //，/user/api/exists,post方式，传username
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/exists"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"username"] = userName;
   [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 重置密码
 */
- (void)doResetPasswordWithPhone:(NSString *)idString andPassword:(NSString *)password andCode:(NSString *)code andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/resetpwd"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"phone"] = idString;
    parameter[@"password"] = [password sha256];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         callback(responseObj);
    }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 接口登录
 */
- (void)doLoginWithUsername:(NSString *)username andPassword:(NSString *)password andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/login"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"username"] = username;
    parameter[@"password"] = [password sha256];
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
/**
 * 获取用户信息
 */
- (void)doGetUserInfoWithSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/user/api/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];}
/**
 * 修改用户信息
 */
- (void)doUpdateUserInfoWithId:(NSString *)idString andName:(NSString *)name andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/code"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"phone"] = idString;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         
     }failure:^(NSError *error)
     {
         
     }];
}

/**
 * 修改密码
 */
- (void)doUpdatePwdWith:(id)object andReason:(NSString *)reason andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/code"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"phone"] = reason;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         
     }failure:^(NSError *error)
     {
         
     }];
}
/**
 * 获取用户信息
 */
- (void)doGetUserInfoWith:(id)object andReason:(NSString *)reason andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"rest/user/api/code"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"phone"] = reason;
    [[CPHttp sharedInstance]postPath:urlStr withParameters:parameter success:^(id responseObj)
     {
         
     }failure:^(NSError *error)
     {
         
     }];
}
/**
 * 获取用户头像
 */
- (void)doGetIconWithSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         callback(responseObj);
     }failure:^(NSError *error)
     {
         failure(error);
     }];
}
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
