//
//  FontConfigure.h
//  chargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCommonFont  @"HelveticaNeueInterface Regular"
#define kIconFont @"iconfont"
#define kNavTitleSize  16.0f
#define kNavButtonItemSize 20.f
#define kHomeIconItemSize 30.f
#define cellTitleSize  11.0f
#define cellContentSize 11.0f
#define cellLargeSize 14.0f
#define kIconFontSize 20.0f
@interface FontConfigure : NSObject

//nav
+ (UIFont *)navTitleFont;
+ (UIFont *)navButtonItemFont;

+ (UIFont *)homeIconItemFont;
//cell
+ (UIFont *)cellTitleFont;
+ (UIFont *)cellContentFont;

+ (UIFont *)cellTitleLargeFont;

+ (UIFont *)commonFont:(CGFloat)font;
@end
