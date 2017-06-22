//
//  CMPAccountInfo.h
//  chargingPile
//
//  Created by RobinLiu on 15/9/8.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPAccountInfo : NSObject

/** 是否登录 */
@property (nonatomic,assign)BOOL isLogin;

/**
 * 用户id
 */
@property (nonatomic,strong)NSString *uid;

/** 登录的手机号码 */
@property (nonatomic, copy) NSString *loginTelephone;

/** 用户名称 */
@property (nonatomic,copy)NSString *name;

/** 地址 */
@property (nonatomic,copy)NSString *address;

/** 性别 m男 f女 */
@property (nonatomic,copy)NSString *gender;

/** 用户头像 */
@property (nonatomic,copy)NSString *icon;

/** 用户身份证 */
@property (nonatomic,copy)NSString *idNo;

/**  */
@property (nonatomic,copy)NSString *invoiceTitle;

/** 用户邮箱 */
@property (nonatomic,copy)NSString *mail;

/** 用户公司 */
@property (nonatomic,copy)NSString *manager;

/** 用户密码 */
@property (nonatomic,copy)NSString *password;

/** 用户支付账号 */
@property (nonatomic,copy)NSString *payAccount;

/** 用户手机 */
@property (nonatomic,copy)NSString *phone;

/** 用户qq */
@property (nonatomic,copy)NSString *qq;

/** 用户余额 */
@property (nonatomic,copy)NSString *remainder;

/** 用户名称 */
@property (nonatomic,copy)NSString *status;

/** 用户类型 
 0  管理员
 1	车主
 2	私人桩主
 3	运营商 */
@property (nonatomic,copy)NSString *types;

/** 用户No */
@property (nonatomic,copy)NSString *userNo;

/** 用户名称 */
@property (nonatomic,copy)NSString *username;

+(CMPAccountInfo *)getSharedInstance;
/**
 * 获取信息
 */
- (void)setDataWithDic:(NSDictionary *)dict;

/**
 * 配置
 */
- (void)initConfigure;

/**
 * 退出登录
 */
- (void)clearData;

/**
 * 记录最近登录用户的信息
 */
- (void)recordLatestLoginUserAccount;

/**
 * 获取最近登录用户的信息
 */
- (CMPAccountInfo *)latestLoginUserAccount;
@end
