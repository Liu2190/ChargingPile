//
//  CPPileEvaHeaderTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvaHeaderTableViewCell.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

@implementation CPPileEvaHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPPileEvaHeaderTableViewCellIdentifier";
    CPPileEvaHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPPileEvaHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kOrderListCellFont;
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        _tip1Label = [[UILabel alloc]init];
        _tip1Label.font = [UIFont systemFontOfSize:8];
        _tip1Label.textColor = [ColorConfigure globalGreenColor];
        _tip1Label.layer.borderWidth = 1.0;
        _tip1Label.textAlignment = NSTextAlignmentCenter;
        _tip1Label.backgroundColor = [UIColor whiteColor];
        _tip1Label.layer.borderColor = [[ColorConfigure globalGreenColor] CGColor];
        _tip1Label.text = @"公共站";
        [self addSubview:_tip1Label];
        
        _tip2Label = [[UILabel alloc]init];
        _tip2Label.font = [UIFont systemFontOfSize:8];
        _tip2Label.textColor = [UIColor orangeColor];
        _tip2Label.layer.borderWidth = 1.0;
        _tip2Label.textAlignment = NSTextAlignmentCenter;
        _tip2Label.backgroundColor = [UIColor whiteColor];
        _tip2Label.layer.borderColor = [[UIColor orangeColor] CGColor];
        _tip2Label.text = @"有空闲";
        [self addSubview:_tip2Label];
        
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = kContentSmallCellFont;
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.numberOfLines = 0;
        [self addSubview:_addressLabel];
        
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.font = kContentSmallCellFont;
        _distanceLabel.textColor = [UIColor grayColor];
        _distanceLabel.numberOfLines = 0;
        [self addSubview:_distanceLabel];
        
        _scoreView = [[CPRatingBar alloc]init];
        [self addSubview:_scoreView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _nameLabel.frame = _headerFrame.pileNameFrame;
    _tip1Label.frame = _headerFrame.tip1Frame;
    _tip2Label.frame = _headerFrame.tip2Frame;
    _addressLabel.frame = _headerFrame.addressFrame;
    _distanceLabel.frame = _headerFrame.distanceFrame;
    _scoreView.frame = _headerFrame.scoreFrame;
}
- (void)setHeaderFrame:(CPPileEvaHeaderFrame *)headerFrame
{
    _tip2Label.hidden = [_headerFrame.listModel.idle intValue] > 0?NO:YES;
    _headerFrame = headerFrame;
    _nameLabel.text = _headerFrame.listModel.name;
    _addressLabel.text = [NSString stringWithFormat:@"地址：%@",_headerFrame.listModel.address];
    _distanceLabel.text = _headerFrame.listModel.distanceAppearance;
    _scoreView.rateValue = [_headerFrame.listModel.star floatValue];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
