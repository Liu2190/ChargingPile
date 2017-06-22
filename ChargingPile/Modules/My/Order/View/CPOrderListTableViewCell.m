//
//  CPOrderListTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/12.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPOrderListTableViewCell.h"
#import "CommonDefine.h"
#import "ColorConfigure.h"

#define kCPPileDetailInfoTableViewCellContentFont [UIFont systemFontOfSize:12]

@implementation CPOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPOrderListTableViewCellIdentifier";
    CPOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 2.0f;
        [self addSubview:_bgView];
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_sepLine];
        
        _timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日期"]];
        [self addSubview:_timeImageView];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.font = kOrderListCellFont;
        [self addSubview:_timeLabel];
        
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [UIColor darkGrayColor];
        _statusLabel.font = kOrderListCellFont;
        [self addSubview:_statusLabel];
        
        _orderNumberLabel = [[UILabel alloc]init];
        _orderNumberLabel.textColor = [ColorConfigure globalGreenColor];
        _orderNumberLabel.font = kOrderListCellFont;
        [self addSubview:_orderNumberLabel];
        
        _orderNumberContentLabel = [[UILabel alloc]init];
        _orderNumberContentLabel.textColor = [ColorConfigure globalGreenColor];
        _orderNumberContentLabel.font = kOrderListCellFont;
        [self addSubview:_orderNumberContentLabel];
        
        _orderNameLabel = [[UILabel alloc]init];
        _orderNameLabel.textColor = [UIColor darkGrayColor];
        _orderNameLabel.font = kOrderListCellFont;
        [self addSubview:_orderNameLabel];
        
        _orderNameContentLabel = [[UILabel alloc]init];
        _orderNameContentLabel.textColor = [UIColor darkGrayColor];
        _orderNameContentLabel.font = kOrderListCellFont;
        [self addSubview:_orderNameContentLabel];
        
        _orderAddressLabel = [[UILabel alloc]init];
        _orderAddressLabel.textColor = [UIColor darkGrayColor];
        _orderAddressLabel.font = kOrderListCellFont;
        [self addSubview:_orderAddressLabel];
        
        _orderAddressContentLabel = [[UILabel alloc]init];
        _orderAddressContentLabel.textColor = [UIColor darkGrayColor];
        _orderAddressContentLabel.font = kOrderListCellFont;
        [self addSubview:_orderAddressContentLabel];
        
        _orderPriceLabel = [[UILabel alloc]init];
        _orderPriceLabel.textColor = [UIColor darkGrayColor];
        _orderPriceLabel.font = kOrderListCellFont;
        [self addSubview:_orderPriceLabel];
        
        _orderPriceContentLabel = [[UILabel alloc]init];
        _orderPriceContentLabel.textColor = [UIColor darkGrayColor];
        _orderPriceContentLabel.font = kOrderListCellFont;
        [self addSubview:_orderPriceContentLabel];
        
        _orderIncomeLabel = [[UILabel alloc]init];
        _orderIncomeLabel.textColor = [UIColor darkGrayColor];
        _orderIncomeLabel.font = kOrderListCellFont;
        [self addSubview:_orderIncomeLabel];
        
        _orderIncomeContentLabel = [[UILabel alloc]init];
        _orderIncomeContentLabel.textColor = [UIColor darkGrayColor];
        _orderIncomeContentLabel.font = kOrderListCellFont;
        [self addSubview:_orderIncomeContentLabel];
        
        _orderTipLabel = [[UILabel alloc]init];
        _orderTipLabel.textColor = [UIColor redColor];
        _orderTipLabel.font = kContentSmallCellFont;
        _orderTipLabel.text = @"月中自动回款到支付宝账号";
        [self addSubview:_orderTipLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame = _listFrame.bgViewframe;
    _sepLine.frame = _listFrame.sepLineframe;
    _timeImageView.frame = _listFrame.timeImageViewframe;
    _timeLabel.frame = _listFrame.timeLabelframe;
    _statusLabel.frame = _listFrame.statusLabelframe;
    _orderNumberLabel.frame = _listFrame.orderNumberframe;
    _orderNameLabel.frame = _listFrame.orderNameframe;
    _orderAddressLabel.frame = _listFrame.orderAddressframe;
    _orderPriceLabel.frame = _listFrame.orderPriceframe;
    _orderIncomeLabel.frame = _listFrame.orderIncomeframe;
    _orderNumberContentLabel.frame = _listFrame.orderNumberContentframe;
    _orderNameContentLabel.frame = _listFrame.orderNameContentframe;
    _orderAddressContentLabel.frame = _listFrame.orderAddressContentframe;
    _orderPriceContentLabel.frame = _listFrame.orderPriceContentframe;
    _orderIncomeContentLabel.frame = _listFrame.orderIncomeContentframe;
    _orderTipLabel.frame = _listFrame.orderTipLabelframe;
}
- (void)setListFrame:(CPOrderListFrame *)listFrame
{
    _listFrame = listFrame;
    _timeLabel.text = _listFrame.listModel.displayTime;
    _statusLabel.text = _listFrame.listModel.orderStatus;
    _orderNumberLabel.text = @"订单号";
    _orderNameLabel.text = @"电桩名称";
    _orderAddressLabel.text = @"电桩位置";
    _orderPriceLabel.text = @"消费金额";
    _orderIncomeLabel.text = @"充电电量";
    _orderNumberContentLabel.text = _listFrame.listModel.orderNo;
    _orderNameContentLabel.text = _listFrame.listModel.pileName;
    _orderAddressContentLabel.text = _listFrame.listModel.address;
    _orderPriceContentLabel.text = _listFrame.listModel.amount;
    _orderIncomeContentLabel.text = _listFrame.listModel.qty;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
