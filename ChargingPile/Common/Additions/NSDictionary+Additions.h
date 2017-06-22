//
//  NSDictionary+Additions.h
//  chargingPile
//
//  Created by chargingPile on 15/1/27.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (BOOL)boolValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)intValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (float)floatValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key defaultValue:(int)defaultValue;

- (NSString *)stringValueForKey:(NSString *)key;
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSArray *)arrayValueForKey:(NSString *)key;

- (NSDictionary *)dictValueForKey:(NSString *)key;


// 用车参数签名
- (NSString *)speCallCarRequestParam;
@end
