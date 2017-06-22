//
//  CPRegisterTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPRegisterTableViewCell.h"

@implementation CPRegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPRegisterTableViewCellIdentifier";
    CPRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPRegisterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _tf = [[UITextField alloc]initWithFrame:CGRectMake(10, 2,kScreenW - 20,42)];
        _tf.textColor = [UIColor darkGrayColor];
        _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_tf];
        
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeButton setBackgroundColor:[ColorConfigure globalGreenColor]];
        [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeButton.layer.cornerRadius = 4.0f;
        _codeButton.frame = CGRectMake(kScreenW - 150, 5, 140,34);
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_codeButton];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
