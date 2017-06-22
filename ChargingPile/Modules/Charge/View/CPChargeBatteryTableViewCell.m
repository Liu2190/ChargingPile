//
//  CPChargeBatteryTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeBatteryTableViewCell.h"
#import "CommonDefine.h"

#define kSpace 15
#define kDuration 10

@interface CPChargeBatteryTableViewCell ()
{
    UIImageView *circleImageView;
}
@end
@implementation CPChargeBatteryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPChargeBatteryTableViewCellIdentifier";
    CPChargeBatteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPChargeBatteryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        circleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"计时"]];
        circleImageView.centerX = kScreenW/2.0;
        circleImageView.centerY = kChargeBatteryTableViewCellHeight/2.0;
        [self addSubview:circleImageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(circleImageView.x,circleImageView.y + 70,circleImageView.width,20)];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = @"充电中";
       // [circleImageView addSubview:titleLabel];
        [self addSubview:titleLabel];

        self.hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(circleImageView.x,circleImageView.y,circleImageView.width,20)];
        self.hourLabel.centerY = circleImageView.height/2.0 + circleImageView.y;
        self.hourLabel.textColor = [UIColor darkGrayColor];
        self.hourLabel.textAlignment = NSTextAlignmentCenter;
        self.hourLabel.font = [UIFont systemFontOfSize:16];
        self.hourLabel.text = @"0h0m";
       // [circleImageView addSubview:self.hourLabel];
        [self addSubview:self.hourLabel];
    }
    return self;
}
- (void)setSecond:(int)second
{
    _second = second;
    int hour = second / 3600;
    int minute = second / 60;
    NSString *str1 = [NSString stringWithFormat:@"%d",hour];
    NSString *str2 = @"h";
    NSString *str3 = [NSString stringWithFormat:@"%d",minute];
    NSString *str4 = @"m";
    NSString *allString = [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange([str1 length],[str2 length])];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange([str1 length] + [str2 length] + [str3 length],[str4 length])];
    self.hourLabel.attributedText = str;
}
-(void)startAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = kDuration;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = CGFLOAT_MAX;
    [circleImageView.layer addAnimation:animation forKey:nil];
}
-(void)endAnimation
{
    [circleImageView.layer removeAllAnimations];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
