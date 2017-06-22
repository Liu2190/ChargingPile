//
//  CPFindPileFooterView.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileFooterView.h"
#import "CommonDefine.h"
#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"
#import "ServerAPI.h"

#define kRightContentWidth 130.0
#define kButtonHeight  35.0

@implementation CPFindPileFooterView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,kScreenW - 10 - kRightContentWidth,self.height - kButtonHeight)];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        UIImage *logo = [UIImage imageNamed:@"品牌"];
        _logoImageView = [[UIImageView alloc]initWithImage:logo];
        _logoImageView.clipsToBounds = YES;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.layer.cornerRadius = logo.size.width/2.0;
        _logoImageView.centerY = 0;
        _logoImageView.centerX = kScreenW - kRightContentWidth + kRightContentWidth/2.0;
        _logoImageView.layer.borderWidth = 3.0f;
        _logoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _logoImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_logoImageView];
        
        _ratingBar = [[CPRatingBar alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_logoImageView.frame), kCPRatingBarWidth, 20)];
        _ratingBar.centerX = _logoImageView.centerX;
        [self addSubview:_ratingBar];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - kRightContentWidth,CGRectGetMaxY(_ratingBar.frame) + 5,kRightContentWidth,20)];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor darkGrayColor];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.numberOfLines = 0;
        [self addSubview:_priceLabel];
        
        
        _publicStationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publicStationButton.frame = self.bounds;
        [self addSubview:_publicStationButton];
        
        UIImage *ig1 = [UIImage imageNamed:@"公共站"];
        _displayPublicStationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _displayPublicStationButton.frame = CGRectMake(_nameLabel.x, self.height - kButtonHeight, ig1.size.width, ig1.size.height);
        [_displayPublicStationButton setImage:ig1 forState:UIControlStateNormal];
        [self addSubview:_displayPublicStationButton];
        
        UIImage *ig2 = [UIImage imageNamed:@"导航"];
        _navButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navButton.frame = CGRectMake(CGRectGetMaxX(_displayPublicStationButton.frame) + 15, 0, ig2.size.width, ig2.size.height);
        _navButton.centerY = _displayPublicStationButton.centerY;
        [_navButton setImage:ig2 forState:UIControlStateNormal];
        [self addSubview:_navButton];
        
        for(UIView *subview in [self subviews])
        {
            subview.userInteractionEnabled = YES;
        }
    }
    return self;
}
- (void)setViewWith:(CPPlieModel *)pileModel andLocation:(CLLocationCoordinate2D)location
{
    _pileModel = pileModel;

    NSString *str1 = [NSString stringWithFormat:@"%@\n",_pileModel.name];
    NSString *str2 = [NSString stringWithFormat:@"地址：%@",_pileModel.address];
    NSString *str3 = @"";
    if(location.latitude > 0 && location.longitude > 0)
    {
        CLLocation *orig = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        CLLocation* dist = [[CLLocation alloc] initWithLatitude:[pileModel.lat doubleValue] longitude:[pileModel.lng doubleValue]];
        CLLocationDistance kilometers = [orig distanceFromLocation:dist];
        str3 = [NSString stringWithFormat:@"\n距离：%.0fm",kilometers];
        if(kilometers > 1000)
        {
            str3 = [NSString stringWithFormat:@"\n距离：%.0fkm",kilometers/1000.0];
        }
    }
    NSString *allString = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,[str1 length])];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange([str1 length],[str2 length] + [str3 length])];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.0];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    _nameLabel.attributedText = str;
    
    _ratingBar.rateValue = [_pileModel.star floatValue];
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,pileModel.userId]] placeholderImage:[UIImage imageNamed:@"品牌"]];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:[NSDate date]];
    NSInteger thisHour = [currentComps hour];
    if((thisHour >= 7 &&thisHour < 8)||(thisHour >= 11 &&thisHour < 15)||(thisHour >= 22 &&thisHour < 23))
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.ping];
    }
    else if(thisHour >= 19 &&thisHour < 22)
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.feng];
    }
    else if((thisHour >= 8 &&thisHour < 11)||(thisHour >= 15 &&thisHour < 19))
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.jian];
    }
    else
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.gu];
    }
}
@end
