//
//  CPMyPileDetailTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDetailTableViewCell.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "FontConfigure.h"
#define kTextFieldWidth (kScreenW - 135)
#define kArrowWidth ([UIImage imageNamed:@"进入"].size.width)
@interface CPMyPileDetailTableViewCell ()
{
    UIImageView *arrowIV;
}
@end
@implementation CPMyPileDetailTableViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPMyPileDetailTableViewCellIdentifier";
    CPMyPileDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPMyPileDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
+ (CGFloat)cellHeightWith:(NSString *)name withArrowHidden:(BOOL)isHidden
{
    CGFloat contentWidth = kTextFieldWidth;
    if(!isHidden)
    {
        contentWidth = contentWidth - kArrowWidth;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
    CGRect dest = [name boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil];
    if(dest.size.height <= 20)
    {
        dest.size.height = 20;
    }
    return dest.size.height + 28;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _infoTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 48)];
        _infoTextLabel.font = [UIFont systemFontOfSize:14];
        _infoTextLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_infoTextLabel];
        
        _infoTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, kTextFieldWidth, 48)];
        _infoTextField.textColor = [UIColor darkGrayColor];
        _infoTextField.textAlignment = NSTextAlignmentRight;
        _infoTextField.font = [UIFont systemFontOfSize:14];
        [self addSubview:_infoTextField];
        
        UIImage *arrowI = [UIImage imageNamed:@"进入"];
        arrowIV = [[UIImageView alloc]initWithImage:arrowI];
        [self addSubview:arrowIV];
        arrowIV.centerY = 24.0;
        arrowIV.x = kScreenW - 15 - kArrowWidth;
        
        _unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 20, 0, 15, 48)];
        _unitLabel.font = [UIFont systemFontOfSize:14];
        _unitLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_unitLabel];
        _unitLabel.hidden = YES;
        
        _moneyIconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 48)];
        _moneyIconLabel.font = [UIFont systemFontOfSize:14];
        _moneyIconLabel.textColor = [UIColor darkGrayColor];
        _moneyIconLabel.text = @"￥";
        [self addSubview:_moneyIconLabel];
        _moneyIconLabel.hidden = YES;
    }
    return self;
}

- (void)setCellWithName:(NSString *)name andTextFiled:(NSString *)text andPlaceHolder:(NSString *)placeHolder andArrowIsHidden:(BOOL)isHidden
{
    CGFloat contentWidth = kTextFieldWidth;
    if(!isHidden)
    {
        contentWidth = contentWidth - kArrowWidth;
    }
    CGFloat cellHeight = 48.0;
   // CGFloat cellHeight = [CPMyPileDetailTableViewCell cellHeightWith:text withArrowHidden:isHidden];
    _infoTextLabel.height = cellHeight;
    _infoTextField.height = cellHeight;
    _infoTextField.width = contentWidth;
    _infoTextField.placeholder = placeHolder;
    arrowIV.centerY = cellHeight/2.0;
    _infoTextLabel.text = name;
    _infoTextField.text = text;
    arrowIV.hidden = isHidden;
}
- (void)setMoneyIconLabelFrame
{
    if(_moneyIconLabel.hidden == NO)
    {
        NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
        attribute[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        CGRect sumRect = [[NSString stringWithFormat:@"￥%@",_infoTextField.text] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        _moneyIconLabel.x = CGRectGetMaxX(_infoTextField.frame) - sumRect.size.width;
        if(_moneyIconLabel.x < _infoTextField.x)
        {
            _moneyIconLabel.x = _infoTextField.x - 15;
        }
    }
}
- (void)setUnitString:(NSString *)unitString
{
    _unitString = unitString;
    _unitLabel.hidden = NO;
    _unitLabel.text = _unitString;
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    CGRect sumRect = [_unitString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _unitLabel.x = kScreenW - sumRect.size.width - 10;
    _unitLabel.width = sumRect.size.width;
    CGFloat maxTFX = CGRectGetMaxX(_infoTextField.frame);
    _infoTextField.width = _infoTextField.width - (maxTFX - _unitLabel.x);
}
@end
