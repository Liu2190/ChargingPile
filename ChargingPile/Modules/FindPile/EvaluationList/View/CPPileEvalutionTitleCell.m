//
//  CPPileEvalutionTitleCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvalutionTitleCell.h"
#import "ServerAPI.h"
#import "UIImageView+WebCache.h"

@implementation CPPileEvalutionTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPPileEvalutionTitleCellIdentifier";
    CPPileEvalutionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPPileEvalutionTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 0.3)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sepLine];
        
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.clipsToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_headerImageView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kOrderListCellFont;
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = kOrderListCellFont;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.numberOfLines = 0;
        [self addSubview:_timeLabel];
        
        _scoreView = [[CPRatingBar alloc]init];
        [self addSubview:_scoreView];
        
        _evalutionLabel = [[UILabel alloc]init];
        _evalutionLabel.font = kOrderListCellFont;
        _evalutionLabel.textColor = [UIColor darkGrayColor];
        _evalutionLabel.numberOfLines = 0;
        [self addSubview:_evalutionLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = kOrderListCellFont;
        [self addSubview:_deleteButton];
        
        _thumbUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thumbUpButton setTitle:@"241" forState:UIControlStateNormal];
        [_thumbUpButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];

        [_thumbUpButton setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
        [_thumbUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _thumbUpButton.titleLabel.font = kOrderListCellFont;
        [self addSubview:_thumbUpButton];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];

        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];

        [_commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = kOrderListCellFont;
        [self addSubview:_commentButton];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _headerImageView.frame = _titleFrame.headerFrame;
    _headerImageView.layer.cornerRadius =  _headerImageView.width/2.0;
    _headerImageView.clipsToBounds = YES;
    _nameLabel.frame = _titleFrame.nameFrame;
    _timeLabel.frame = _titleFrame.timeFrame;
    _scoreView.frame = _titleFrame.scoreFrame;
    _evalutionLabel.frame = _titleFrame.evalutionFrame;
    _deleteButton.frame = _titleFrame.deleteFrame;
    _thumbUpButton.frame = _titleFrame.thumbUpFrame;
    _commentButton.frame = _titleFrame.commentFrame;
}
- (void)setTitleFrame:(CPPileEvalutionTitleFrame *)titleFrame
{
    _titleFrame = titleFrame;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,_titleFrame.listModel.userId]]];
    _nameLabel.text = _titleFrame.listModel.userName;
    _timeLabel.text = _titleFrame.listModel.displayTime;
    if(_titleFrame.listModel.type == CPPileEvalutionModelTypeMy)
    {
        _scoreView.rateValue = [_titleFrame.listModel.stationStar floatValue];
    }
    _evalutionLabel.text = _titleFrame.listModel.content;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
