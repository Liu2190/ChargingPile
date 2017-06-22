//
//  CPSearchConditionView.m
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/19.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import "CPSearchConditionView.h"
#define kArrorHeight    8.0
@implementation CPSearchConditionBGView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
     CGContextSetLineWidth(context, 1.0);
     CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    [self getDrawPath:context];
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 4.0;//边框的角
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect) + kArrorHeight,
    maxy = CGRectGetMaxY(rrect) ;
    
    CGContextMoveToPoint(context, midx - kArrorHeight/2.0, miny);
    CGContextAddLineToPoint(context,midx, miny - kArrorHeight);
    CGContextAddLineToPoint(context,midx + kArrorHeight/2.0, miny);
    
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, minx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    
    CGContextClosePath(context);
}
@end

@interface CPSearchConditionView ()<UIGestureRecognizerDelegate>
{
    CPSearchConditionViewBlock privateBlock;
    CPSearchConditionBGView *bgView;
}
@end
@implementation CPSearchConditionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (CPSearchConditionView *)sharedInstance
{
    static dispatch_once_t onceToken;
    static CPSearchConditionView *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[CPSearchConditionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        bgView = [[CPSearchConditionBGView alloc] initWithFrame:CGRectMake(25, 55, 100, 80 + kArrorHeight)];
        [self addSubview:bgView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, kArrorHeight, bgView.width, 40);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [cancelBtn setTitle:kConditionLocation forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(0, kArrorHeight + 40, bgView.width, 40);
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [sureBtn setTitle:kConditionName forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:sureBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, sureBtn.y, bgView.width - 10, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:line];
        
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"bgView"]) {
        return NO;
    }
    return  YES;
}
- (void)tappedCancel
{
    [self removeFromSuperview];
}
- (void)confirmAction:(UIButton *)sender
{
    privateBlock([sender.currentTitle isEqualToString:kConditionName]?YES:NO);
    [self tappedCancel];
}

- (void)showPickerViewWithBlock:(CPSearchConditionViewBlock)block
{
    [self endEditing:YES];
    privateBlock = block;
    [[[[UIApplication sharedApplication] delegate] window]addSubview:self];
}
@end
