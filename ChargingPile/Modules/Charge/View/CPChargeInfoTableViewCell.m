//
//  CPChargeInfoTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/6.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeInfoTableViewCell.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

@interface CPChargeInfoTableViewCell()
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;

}
@end
@implementation CPChargeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPChargeInfoTableViewCellIdentifier";
    CPChargeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPChargeInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0 ,200,15)];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.text = @"您的详细指数为：";
        [self addSubview:nameLabel];
        
        NSArray *titleArray = @[@"电流",@"电压",@"电量金额",@"电量度数"];
        NSArray *imageArray = @[@"3-充电中_03",@"3-充电中_05",@"3-充电中_07",@"3-充电中_09"];
        
        CGFloat space = (kScreenW - 4.0 * 40.0 )/5.0;
        for(int i = 0;i < titleArray.count;i++)
        {
            UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArray[i]]];
            bgImageView.centerY = 50;
            bgImageView.centerX = (space + 40.0)*i + space + 20.0;
            [self addSubview:bgImageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,80,15)];
            titleLabel.centerX = bgImageView.centerX;
            titleLabel.centerY = CGRectGetMaxY(bgImageView.frame) + 13;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleArray[i];
            [self addSubview:titleLabel];
            
            UILabel *title1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,70,15)];
            title1Label.centerX = bgImageView.centerX;
            title1Label.centerY = CGRectGetMaxY(titleLabel.frame) + 13;
            title1Label.textColor = [ColorConfigure globalGreenColor];
            title1Label.font = [UIFont systemFontOfSize:13];
            title1Label.textAlignment = NSTextAlignmentCenter;
            title1Label.text = @"100MH";
            if(i == 0)
            {
                label1 = title1Label;
            }
            if(i == 1)
            {
                label2 = title1Label;
            }
            if(i == 2)
            {
                label3 = title1Label;
            }
            if(i == 3)
            {
                label4 = title1Label;
            }
            [self addSubview:title1Label];
        }
    }
    return self;
}
- (void)setModel:(CPChargeProduceModel *)model
{
    label1.text = [NSString stringWithFormat:@"%@A",model.electricCurrent];
    label2.text = [NSString stringWithFormat:@"%@V",model.voltage];
    label3.text = [NSString stringWithFormat:@"%@¥",model.amountAlectricity];
    label4.text = [NSString stringWithFormat:@"%@kw/h",model.electricQuantityDegree];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
