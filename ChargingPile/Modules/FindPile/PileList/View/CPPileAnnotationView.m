//
//  CPPileAnnotationView.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileAnnotationView.h"
#import "CustomCalloutView.h"
#import "UIImageView+WebCache.h"
#import "CPPileAnnotation.h"
#import "ColorUtility.h"

#define kWidth  33.0f
#define kHeight 46.0f

#define kLogoImageWidth (kWidth - 6.0)

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kCalloutWidth   150.0
#define kCalloutHeight  64.0
#define kHotelListCellPlaceHolderImage @"hotellist_cell_placeHolderImage"

@interface CPPileAnnotationView ()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *cancelLabel;
@property (nonatomic,strong)UIImageView *logoImageView;

@end

@implementation CPPileAnnotationView

@synthesize calloutView;
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        self.image = [UIImage imageNamed:@"findPile_dingwei"];
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLogoImageWidth, kLogoImageWidth)];
        self.logoImageView.centerX = kWidth/2.0 - 0.5;
        self.logoImageView.backgroundColor = [UIColor whiteColor];
        self.logoImageView.centerY = kLogoImageWidth/2.0 + 3;
        [self addSubview:self.logoImageView];
    }
    return self;
}
- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
}
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]placeholderImage:[UIImage imageNamed:@"品牌"]];
    _logoImageView.clipsToBounds = YES;
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.layer.cornerRadius = kLogoImageWidth/2.0;
}
- (void)updateImageView
{
    CPPileAnnotation *annotation = (CPPileAnnotation *)self.annotation;
    if(annotation.pileModel != nil)
    {
        self.nameLabel.text = annotation.pileModel.name;
        self.typeLabel.text = annotation.pileModel.operatorName;
    }
}
#pragma mark - Handle Action

- (void)btnAction
{
    CPPileAnnotation *annotation = (CPPileAnnotation *)self.annotation;
    [[NSNotificationCenter defaultCenter]postNotificationName:kCPPileAnnotationViewNotification object:nil userInfo:@{@"index":[NSNumber numberWithInteger:annotation.index]}];
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSLog(@"self.selected = %d",self.selected);
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y+5);
            
            self.cancelLabel = [[UILabel alloc]init];
            self.cancelLabel.frame = CGRectMake(self.calloutView.width - 20, 9, 11, 11);
            self.cancelLabel.text = @"x";
            self.cancelLabel.font = [UIFont boldSystemFontOfSize:10];
            self.cancelLabel.textAlignment = NSTextAlignmentCenter;
            self.cancelLabel.textColor = [ColorUtility colorFromHex:0x625cdb];
            self.cancelLabel.layer.cornerRadius = 2.0f;
            self.cancelLabel.layer.borderWidth = 1.0f;
            self.cancelLabel.layer.borderColor = [[ColorUtility colorFromHex:0x625cdb] CGColor];
            [self.calloutView addSubview:self.cancelLabel];
            
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.cancelLabel.x - 10, 16)];
            self.nameLabel.textColor = [ColorUtility colorFromHex:0xe1a7a1];
            self.nameLabel.font = [UIFont systemFontOfSize:12];
            [self.calloutView addSubview:self.nameLabel];
            
            self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxX(self.nameLabel.frame) + 2, self.nameLabel.width, 15)];
            self.typeLabel.textColor = [UIColor darkGrayColor];
            self.typeLabel.font = [UIFont systemFontOfSize:10];
            [self.calloutView addSubview:self.typeLabel];
            [self updateImageView];
        }
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}
@end
