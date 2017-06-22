//
//  CPDynamicDetailContentTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicDetailContentTableViewCell.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

#define kContentFont [UIFont systemFontOfSize:13]
#define kSpace 20

@implementation CPDynamicDetailContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPDynamicDetailContentTableViewCellIdentifier";
    CPDynamicDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPDynamicDetailContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, kSpace, kScreenW - 2.0*kSpace, 20)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.font = kContentFont;
        [self addSubview:_contentLabel];
    }
    return self;
}
+ (CGFloat)cellHeightWith:(NSString *)content
{
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kContentFont;
    
    CGRect nameRect = [content boundingRectWithSize:CGSizeMake(kScreenW - 2.0*kSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return nameRect.size.height + 2 * kSpace;
}
- (void)setCellContent:(NSString *)content
{
    _contentLabel.text = content;
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kContentFont;
    
    CGRect nameRect = [content boundingRectWithSize:CGSizeMake(kScreenW - 2.0*kSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _contentLabel.height = nameRect.size.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
