//
//  CPDynamicDetailTitleTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicDetailTitleTableViewCell.h"
#import "CommonDefine.h"

#define kSpace 10
#define kContentFont [UIFont systemFontOfSize:12]
#define kTitleFont [UIFont systemFontOfSize:15]

@implementation CPDynamicDetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPDynamicDetailTitleTableViewCellIdentifier";
    CPDynamicDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPDynamicDetailTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, kSpace, kScreenWidth - 2 *kSpace, 15)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = kTitleFont;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, kSpace, kScreenWidth - 2 *kSpace, 15)];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = kContentFont;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    return self;
}
+ (CGFloat)cellHeightWith:(NSString *)title andTime:(NSString *)time;
{
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kTitleFont;
    
    CGRect nameRect = [title boundingRectWithSize:CGSizeMake(kScreenW - 2.0*kSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return nameRect.size.height + kSpace *3 + 15;
}
- (void)setCellContent:(NSString *)title andTime:(NSString *)time
{
    _titleLabel.text = title;
    _timeLabel.text = [NSString stringWithFormat:@"发布日期：%@",time];
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kTitleFont;
    
    CGRect nameRect = [title boundingRectWithSize:CGSizeMake(kScreenW - 2.0*kSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _titleLabel.height = nameRect.size.height;
    _timeLabel.y = CGRectGetMaxY(_titleLabel.frame) + kSpace;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
