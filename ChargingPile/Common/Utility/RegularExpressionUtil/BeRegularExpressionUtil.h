//
//  BeRegularExpressionUtil.h
//  SideBenefit
//
//  Created by chargingPile on 15/3/5.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeRegularExpressionUtil : NSObject
/**
 * 邮箱验证
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 * 手机号码验证
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 * 车牌号验证
 */
+ (BOOL)validateCarNo:(NSString *)carNo;

/**
 * 车型验证
 */
+ (BOOL)validateCarType:(NSString *)CarType;

/**
 * 用户名验证
 */
 + (BOOL)validateUserName:(NSString *)name;

/**
 * 密码验证
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**
 * 昵称验证
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/**
 * 身份证验证
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 * 银行卡验证
 */
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber;

/**
 * 银行卡后四位验证
 */
+ (BOOL)validateBankCardLastNumber:(NSString *)bankCardNumber;

/**
 * cvn验证
 */
+ (BOOL)validateCVNCode:(NSString *)cvnCode;

/**
 * 月验证
 */
+ (BOOL)validateMonth:(NSString *)month;

/**
 * 年验证
 */
+ (BOOL)validateYear:(NSString *)year;

/**
 * verifyCode验证
 */
+ (BOOL)validateVerifyCode:(NSString *)verifyCode;
/**
 * 是否为中文验证
 */
+ (BOOL)verifyIsChinese:(NSString *)string;

// 企业名称
+ (BOOL)validatCompanyName:(NSString *)companyName;
@end
