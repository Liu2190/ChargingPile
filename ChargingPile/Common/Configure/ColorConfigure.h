//
//  ColorConfigure.h
//  chargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorUtility.h"

@interface ColorConfigure : NSObject

//NavColor
+ (UIColor *)navTitleColor;
+ (UIColor *)navShadowColor;
+ (UIColor *)navBarColor;

//CommonCellColor
+ (UIColor *)cellTitleColor;
+ (UIColor *)cellContentColor;
+ (UIColor *)cellTimeColor;
+ (UIColor *)cellRedDotColor;
+ (UIColor *)cellMarkTitleColor;//标题为重点显示时的颜色

//login
+ (UIColor *)loginButtonColor;//登录按钮的颜色
+ (UIColor *)unableButtonColor;//按钮失效时的颜色

//textfiled
+ (UIColor *)textFieldPlaceHolderColor;

+ (UIColor *)lineGrayColor;
+ (UIColor *)lightGreenColor;

+ (UIColor *)globalGreenColor;
+ (UIColor *)globalBlueColor;
+ (UIColor *)globalRedColor;
+ (UIColor *)globalTextColor;
+ (UIColor *)globalLineColor;
@end
