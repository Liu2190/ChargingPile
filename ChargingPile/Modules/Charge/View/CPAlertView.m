//
//  CPAlertView.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/10.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPAlertView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

static CPAlertView *_instance = nil;
@interface CPAlertView()
{
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIButton *confirmButton;
    AlertViewBlock privateBlock;
}
@end
@implementation CPAlertView
+ (CPAlertView *)sharedInstance
{
    if(_instance == nil)
    {
        @synchronized(self)
        {
            if(!_instance)
            {
                _instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            }
        }
    }
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        CGFloat cornerRadius = 4.0;
        CGFloat bannerHeight = 40.0f;
        self.userInteractionEnabled = YES;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(80, 0, kScreenWidth - 160, 160)];
        bgView.centerY = kScreenH/2.0;
        bgView.layer.cornerRadius = cornerRadius;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.width, bannerHeight)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [ColorConfigure globalGreenColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"提示";
        titleLabel.font = [UIFont systemFontOfSize:17];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = titleLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        titleLabel.layer.mask = maskLayer;
        [bgView addSubview:titleLabel];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), bgView.width, bgView.height - bannerHeight * 2.0f)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textColor = [ColorConfigure globalGreenColor];
        [bgView addSubview:contentLabel];
        
        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(0, bgView.height - bannerHeight,bgView.width, bannerHeight);
        confirmButton.layer.cornerRadius = 2.0f;
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [confirmButton setTitleColor:[ColorConfigure globalGreenColor] forState:UIControlStateNormal];
        [confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:confirmButton];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLabel.frame) - 0.5, bgView.width, 0.5)];
        sepView.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:sepView];
        
    }
    return self;
}
- (void)confirmAction
{
    if(privateBlock)
    {
        privateBlock();
    }
    self.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
}
- (void)showViewWithTitle:(NSString *)title andContent:(NSString *)content andBlock:(AlertViewBlock)block
{
    titleLabel.text = title;
    contentLabel.text = content;
    privateBlock = block;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
     }completion:^(BOOL finished)
     {
         
     }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
