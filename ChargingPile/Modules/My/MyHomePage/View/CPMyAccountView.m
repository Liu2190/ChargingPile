//
//  CPMyAccountView.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyAccountView.h"


@implementation CPMyAccountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
         self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navImage"]];
        _accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 80, 80)];
        _accountImageView.x = kScreenW/2.0 - 40;
        _accountImageView.clipsToBounds = YES;
        _accountImageView.layer.cornerRadius = 40.f;
        [self addSubview:_accountImageView];
        
        _accountNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, 20)];
        _accountNameLabel.textColor = [UIColor whiteColor];
        _accountNameLabel.textAlignment = NSTextAlignmentCenter;
        _accountNameLabel.font = [UIFont systemFontOfSize:15];
        _accountNameLabel.text = @"默认aaa";
        [self addSubview:_accountNameLabel];
        [self changeSubviewsFrame];
        for(UIView *subview in [self subviews])
        {
            subview.userInteractionEnabled = YES;
        }
    }
    return self;
}
- (void)changeSubviewsFrame
{
    _accountImageView.y = self.height - 130;
    _accountNameLabel.y = self.height - 40;
}
- (void)setSourceType:(CPMyAccountViewType)sourceType
{
    _sourceType = sourceType;
    if(sourceType == CPMyAccountViewTypeDetail)
    {
        UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountBg"]];
        imageview.userInteractionEnabled = YES;
        imageview.clipsToBounds = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:imageview];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = imageview.bounds;
        effectview.alpha = .4f;
        [imageview addSubview:effectview];
        [self bringSubviewToFront:_accountImageView];
        [self bringSubviewToFront:_accountNameLabel];
    }
}
- (void)setAccountImageWith:(UIImage *)image
{
    _accountImageView.image = image;
    _accountImageView.contentMode = UIViewContentModeScaleAspectFill;
    _accountImageView.clipsToBounds = YES;
}
@end
