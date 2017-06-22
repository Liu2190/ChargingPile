//
//  CPChargeProduceTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeProduceTableViewCell.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

#define kSpace 15
@interface  CPChargeProduceTableViewCell()
{
    UIImageView *barImageView;
    UIImageView *indicatorImageView;
}
@end

@implementation CPChargeProduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPChargeProduceTableViewCellIdentifier";
    CPChargeProduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPChargeProduceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        barImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进度条"]];
        barImageView.centerX = kScreenW/2.0;
        barImageView.y = 19;
        [self addSubview:barImageView];
        
        indicatorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"充电中"]];
        indicatorImageView.x = barImageView.x - indicatorImageView.width/2.0f;
        indicatorImageView.y = 0;
        [self addSubview:indicatorImageView];
        
        NSArray *titleArray = @[@"0",@"30%",@"70%",@"100%"];
        NSArray *colorArray = @[[ColorConfigure globalGreenColor],[ColorConfigure globalGreenColor],[UIColor orangeColor],[UIColor orangeColor]];
        for(int i = 0;i < titleArray.count;i++)
        {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35 ,40,15)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            switch (i) {
                case 0:
                {
                    titleLabel.centerX = barImageView.x;
                }
                    break;
                case 1:
                {
                    titleLabel.centerX = barImageView.x + barImageView.width * 0.3;
                }
                    break;
                case 2:
                {
                    titleLabel.centerX = barImageView.x + barImageView.width * 0.7;
                }
                    break;
                case 3:
                {
                    titleLabel.centerX = barImageView.x + barImageView.width * 1;
                }
                    break;
                    
                default:
                    break;
            }
            titleLabel.textColor = colorArray[i];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleArray[i];
            [self addSubview:titleLabel];
        }
    }
    return self;
}
- (void)setPercent:(CGFloat)percent
{
    _percent = percent/100.0;
    indicatorImageView.x = barImageView.x - indicatorImageView.width/2.0f + barImageView.width * _percent;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
