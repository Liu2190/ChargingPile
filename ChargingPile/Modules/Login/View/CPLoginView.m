//
//  CPLoginView.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPLoginView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "BeRegularExpressionUtil.h"
#import "CommonDefine.h"

#define kEnterNamePlaceHolder @"请输入账号"
#define kEnterPasswordPlaceHolder @"请输入密码"
#define kUnableAlpha 0.5
@implementation CPLoginView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _loginNameTF = [[UITextField alloc]initWithFrame:CGRectMake(45, 0, kScreenWidth- 90, 50)];
        _loginNameTF.textColor = [UIColor whiteColor];
        _loginNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _loginNameTF.keyboardType = UIKeyboardTypePhonePad;
        _loginNameTF.placeholder = kEnterNamePlaceHolder;
        UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"请输入手机号"]];
        UIView *img1BG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, _loginNameTF.height)];
        img1.x = 0;
        img1.centerY = img1BG.centerY;
        [img1BG addSubview:img1];
        _loginNameTF.leftView = img1BG;
        _loginNameTF.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:_loginNameTF];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(_loginNameTF.x, CGRectGetMaxY(_loginNameTF.frame)-2, _loginNameTF.width, 0.5)];
        line1.backgroundColor = [UIColor whiteColor];
        [self addSubview:line1];
        
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(_loginNameTF.x, _loginNameTF.height + 2, _loginNameTF.width,_loginNameTF.height)];
        _passwordTF.textColor = [UIColor whiteColor];
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTF.placeholder = kEnterPasswordPlaceHolder;
        _passwordTF.secureTextEntry = YES;
        UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"请输入密码"]];
        UIView *img2BG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, _passwordTF.height)];
        img2.x = 0;
        img2.centerY = img2BG.centerY;
        [img2BG addSubview:img2];
        _passwordTF.leftView = img2BG;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:_passwordTF];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_passwordTF.x, CGRectGetMaxY(_passwordTF.frame)-2, _passwordTF.width, 0.5)];
        line2.backgroundColor = [UIColor whiteColor];
        [self addSubview:line2];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setBackgroundColor:[UIColor whiteColor]];
        [_loginButton setTitleColor:[ColorConfigure globalGreenColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 4.0f;
        _loginButton.frame = CGRectMake(30, CGRectGetMaxY(_passwordTF.frame) + 20, kScreenWidth-60,50);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_loginButton];
        
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_registerButton setBackgroundColor:[UIColor clearColor]];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerButton.frame = CGRectMake(_loginButton.x, CGRectGetMaxY(_loginButton.frame) + 5, 30, 20);
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [self addSubview:_registerButton];
        
        _identifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _identifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_identifyCodeBtn setBackgroundColor:[UIColor clearColor]];
        [_identifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _identifyCodeBtn.frame = CGRectMake(CGRectGetMaxX(_loginButton.frame) - 75, _registerButton.y, 75, _registerButton.height);
        [_identifyCodeBtn setTitle:@"  忘记密码" forState:UIControlStateNormal];
        [_identifyCodeBtn setImage:[UIImage imageNamed:@"忘记密码"] forState:UIControlStateNormal];
        [self addSubview:_identifyCodeBtn];
    }
    return self;
}
@end
