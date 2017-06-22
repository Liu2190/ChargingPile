//
//  DataCheckUtil.h
//  qiuyingios
//
//  Created by musmile on 14-2-14.
//  Copyright (c) 2014年 zdqk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCheckUtil : NSObject

//检查输入文字的检查,检查是否是，数字，字符串,-,_
+(BOOL) isNumAndAscaii:(NSString*)aStiring;

//检查输入文字是否是符号
+(BOOL) isSymbol:(NSString*)aString;

//判断字符串是否全部是中文
+(BOOL) isAllChinese:(NSString*)aString;

//判断是否是手机号码
+(BOOL)isPhoneNumInput:(NSString*)aPhoneNum;

//邮箱校验
+(BOOL) isEmail:(NSString*)aEmailString;

//检查输入文字的检查,检查是否是，数字，.
+(BOOL)isNumAndDecimalPoint:(NSString*)aStiring;

@end
