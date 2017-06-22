//
//  DataCheckUtil.m
//  qiuyingios
//
//  Created by musmile on 14-2-14.
//  Copyright (c) 2014年 zdqk. All rights reserved.
//

#import "DataCheckUtil.h"

@implementation DataCheckUtil

//检查输入文字的检查,检查是否是，数字，字符串,-,_
+(BOOL) isNumAndAscaii:(NSString*)aStiring
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet
characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"]invertedSet];
    //过滤掉不是字母数字的字符
    NSString* getString = [aStiring stringByTrimmingCharactersInSet:nameCharacters];

    if ([getString isEqualToString:aStiring]) {
        return YES;
    }
    
    return NO;
}

//检查输入文字是否是符号
+(BOOL) isSymbol:(NSString*)aString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet
characterSetWithCharactersInString:@"!@#$%^&*()_-+=~`{}[]<>,.?/;:"]invertedSet];
    //过滤掉不是字母数字的字符
    NSString* getString = [aString stringByTrimmingCharactersInSet:nameCharacters];
    
    if ([getString isEqualToString:aString]) {
        return YES;
    }
    
    return NO;
}

//判断字符串是否全部是中文
+(BOOL) isAllChinese:(NSString*)aString
{
    BOOL isAll = YES;
    
    for (int i=0; i<[aString length]; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [aString substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) != 3)
        {
            isAll = NO;
            break;
        }
    }
    
    return isAll;
}

+(BOOL)isPhoneNumInput:(NSString*)aPhoneNum{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:aPhoneNum];
    BOOL res2 = [regextestcm evaluateWithObject:aPhoneNum];
    BOOL res3 = [regextestcu evaluateWithObject:aPhoneNum];
    BOOL res4 = [regextestct evaluateWithObject:aPhoneNum];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+(BOOL)isEmail:(NSString *)aEmailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:aEmailString];
}


//检查输入文字的检查,检查是否是，数字，.
+(BOOL)isNumAndDecimalPoint:(NSString*)aStiring
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet
                                       characterSetWithCharactersInString:@"0123456789."]invertedSet];
    //过滤掉不是字母数字的字符
    NSString* getString = [aStiring stringByTrimmingCharactersInSet:nameCharacters];
    
    if ([getString isEqualToString:aStiring]) {
        return YES;
    }
    
    return NO;
}


@end
