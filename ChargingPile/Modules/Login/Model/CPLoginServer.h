//
//  CPLoginServer.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/18.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPLoginServer : NSObject

/**
 * 获取短信验证码
 */
- (void)doGetSMSVerificationCodeWith:(NSString *)phone andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
/**
 * 校验短信验证码
 */
- (void)doCheckSMSVerificationCodeWith:(NSString *)phone andCode:(NSString *)code andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 用户注册
 */
- (void)doRegisterWithUsername:(NSString *)username andName:(NSString *)name andPassword:(NSString *)password andSuccess:(void (^)( id))callback andFailure:(void (^)(id))failure;
/**
 * 注册的时候查看时候注册过
 */
- (void)checkPhoneIsRegisteredWithUserName:(NSString *)userName andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 重置密码
 */
- (void)doResetPasswordWithPhone:(NSString *)idString andPassword:(NSString *)password andCode:(NSString *)code andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 接口登录
 */
- (void)doLoginWithUsername:(NSString *)username andPassword:(NSString *)password andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 获取用户信息
 */
- (void)doGetUserInfoWithSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 修改用户信息
 */
- (void)doUpdateUserInfoWithId:(NSString *)idString andName:(NSString *)name andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;

/**
 * 修改密码
 */
- (void)doUpdatePwdWith:(id)object andReason:(NSString *)reason andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 获取用户信息
 */
- (void)doGetUserInfoWith:(id)object andReason:(NSString *)reason andSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 获取用户头像
 */
- (void)doGetIconWithSuccess:(void (^)(id))callback andFailure:(void (^)(id))failure;
/**
 * 文件下载
 */
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress;
@end
