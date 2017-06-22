//
//  CMPAccountInfo.m
//  chargingPile
//
//  Created by RobinLiu on 15/9/8.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "CMPAccountInfo.h"
#import "CommonDefine.h"
#import "NSDictionary+Additions.h"
#import "SDImageCache.h"
#import "ServerAPI.h"

@implementation CMPAccountInfo

static CMPAccountInfo *instance = nil;
+(CMPAccountInfo*)getSharedInstance
{
    if(instance ==nil){
        @synchronized (self)
        {
            if(!instance)
            {
                instance = [[CMPAccountInfo alloc] init];
            }
        }
    }
    return instance;
}
- (id)init
{
    if(self = [super init])
    {
        _isLogin = NO;
    }
    return self;
}
- (void)setDataWithDic:(NSDictionary *)userInfo
{
    [self setIsLogin:YES];
    [self setName:[userInfo stringValueForKey:@"name" defaultValue:@""]];
    _address = [userInfo stringValueForKey:@"address" defaultValue:@""];
    _gender = [userInfo stringValueForKey:@"gender" defaultValue:@""];
    _icon = [userInfo stringValueForKey:@"icon" defaultValue:@""];
    _idNo = [userInfo stringValueForKey:@"idNo" defaultValue:@""];
    _invoiceTitle = [userInfo stringValueForKey:@"invoiceTitle" defaultValue:@""];
    _mail = [userInfo stringValueForKey:@"mail" defaultValue:@""];
    _manager = [userInfo stringValueForKey:@"manager" defaultValue:@""];
    _password = [userInfo stringValueForKey:@"password" defaultValue:@""];
    _payAccount = [userInfo stringValueForKey:@"payAccount" defaultValue:@""];
    _phone = [userInfo stringValueForKey:@"phone" defaultValue:@""];;
    _qq = [userInfo stringValueForKey:@"qq" defaultValue:@""];
    _remainder = [userInfo stringValueForKey:@"remainder" defaultValue:@""];
    _status = [userInfo stringValueForKey:@"status" defaultValue:@""];
    _types = [userInfo stringValueForKey:@"types" defaultValue:@""];
    _userNo = [userInfo stringValueForKey:@"userNo" defaultValue:@""];
    _username = [userInfo stringValueForKey:@"username" defaultValue:@""];
}

- (void)recordLatestLoginUserAccount
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_loginTelephone forKey:@"loginTelephone"];
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:kLatestLoginUserAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (CMPAccountInfo *)latestLoginUserAccount
{
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:kLatestLoginUserAccount];
    CMPAccountInfo *model = [[CMPAccountInfo alloc]init];
    model.loginTelephone = [dict objectForKey:@"loginTelephone"];
    return model;
}

- (void)initConfigure
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id defaultConfig = nil;
    
    defaultConfig = [ud objectForKey:@"isLogin"];
    
    _isLogin = [defaultConfig boolValue];
    if(defaultConfig == nil )
    {
        _isLogin = NO;
    }
    defaultConfig = nil;
    
    defaultConfig = [ud objectForKey:@"loginTelephone"];
    if(defaultConfig)
    {
        _loginTelephone = [(NSString *)defaultConfig copy];
        defaultConfig = nil;
    }
    defaultConfig = [ud objectForKey:@"uid"];
    if(defaultConfig)
    {
        _uid = [(NSString *)defaultConfig copy];
        defaultConfig = nil;
    }
    
    defaultConfig = [ud objectForKey:@"name"];
    if(defaultConfig)
    {
        _name = [(NSString *)defaultConfig copy];
        defaultConfig = nil;
    }
    defaultConfig = nil;
}
- (void)clearData
{
    [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,_uid]];
}
- (void)setIsLogin:(BOOL)isLogin
{
    if (_isLogin == isLogin) {
        return;
    }
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isLogin] forKey:@"isLogin"];
}
- (void)setLoginTelephone:(NSString *)loginTelephone
{
    if(_loginTelephone == loginTelephone)
    {
        return;
    }
    _loginTelephone = loginTelephone;
    [[NSUserDefaults standardUserDefaults]setObject:loginTelephone forKey:@"loginTelephone"];
}
- (void)setUid:(NSString *)uid
{
    if(_uid == uid)
    {
        return;
    }
    _uid = uid;
    [[NSUserDefaults standardUserDefaults]setObject:uid forKey:@"uid"];
}
- (void)setName:(NSString *)name
{
    if(_name == name)
    {
        return;
    }
    _name = name;
    [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name"];
}

@end
