//
//  CPDynamicListTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicListTableViewCell.h"
#import "CommonDefine.h"

#define kSpace 15
@implementation CPDynamicListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPDynamicListTableViewCellIdentifier";
    CPDynamicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPDynamicListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _listImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSpace, kSpace, kDynamicListHeight, kDynamicListHeight - 2.0 * kSpace)];
        _listImageView.contentMode = UIViewContentModeScaleAspectFill;
        _listImageView.clipsToBounds = YES;
        _listImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_listImageView];
        
        _listTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_listImageView.frame) + kSpace, _listImageView.x, kScreenWidth - CGRectGetMaxX(_listImageView.frame) - 2 *kSpace, 15)];
        _listTitleLabel.textColor = [UIColor darkGrayColor];
        _listTitleLabel.font = [UIFont systemFontOfSize:13];
        _listTitleLabel.text = @"默认aaa";
        [self addSubview:_listTitleLabel];
        
        _listContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_listTitleLabel.x, CGRectGetMaxY(_listTitleLabel.frame) + kSpace, _listTitleLabel.width, _listTitleLabel.height)];
        _listContentLabel.textColor = [UIColor darkGrayColor];
        _listContentLabel.font = [UIFont systemFontOfSize:13];
        _listContentLabel.text = @"默认aaa";
        [self addSubview:_listContentLabel];
        
        _listtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_listTitleLabel.x, CGRectGetMaxY(_listContentLabel.frame) + kSpace, _listTitleLabel.width, _listTitleLabel.height)];
        _listtimeLabel.textColor = [UIColor grayColor];
        _listtimeLabel.font = [UIFont systemFontOfSize:11];
        _listtimeLabel.text = @"默认aaa";
        [self addSubview:_listtimeLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
