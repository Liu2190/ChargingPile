//
//  CPPileDetailInfoTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileDetailInfoTableViewCell.h"
#import "CommonDefine.h"
#define kCPPileDetailInfoTableViewCellContentFont [UIFont systemFontOfSize:13]

@implementation CPPileDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPPileDetailInfoTableViewCellIdentifier";
    CPPileDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPPileDetailInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
+ (CGFloat)cellHeightWith:(NSString *)cellContent
{
    if(cellContent == nil)
    {
        return 50.0f;
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary * attributes = @{NSFontAttributeName : kCPPileDetailInfoTableViewCellContentFont,NSParagraphStyleAttributeName:paragraphStyle};
    CGRect cellContentRect = [cellContent boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil];
    return cellContentRect.size.height < 50 ? 50:cellContentRect.size.height;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,100,50.f)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
        
        _contentLabel= [[UILabel alloc]initWithFrame:CGRectMake(10,0 ,kScreenW - 20,50.0)];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = kCPPileDetailInfoTableViewCellContentFont;
        _contentLabel.text = @"";
        [self addSubview:_contentLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
