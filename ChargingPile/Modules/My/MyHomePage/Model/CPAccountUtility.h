//
//  CPAccountUtility.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPAccountUtility : NSObject
+(CPAccountUtility*)getSharedInstance;
#pragma mark - 上传用户头像
- (void)startUploadUserHeaderIconWith:(NSData *)imageData withSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
#pragma mark - 修改用户信息
- (void)updateUserInfoWith:(NSDictionary *)userInfo andSuccessCallback:(void (^)(id ))callback andFailureCallback:(void (^)(id))failure;
@end
