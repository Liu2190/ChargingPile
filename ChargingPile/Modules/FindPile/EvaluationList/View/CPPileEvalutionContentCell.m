//
//  CPPileEvalutionContentCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvalutionContentCell.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

@implementation CPPileEvalutionContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPPileEvalutionContentCellIdentifier";
    CPPileEvalutionContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPPileEvalutionContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [ColorUtility colorFromHex:0xeeeeee];
        _bgView.layer.cornerRadius = 3.0f;
        [self addSubview:_bgView];
        
        _replyLabel = [[UILabel alloc]init];
        _replyLabel.font = kOrderListCellFont;
        _replyLabel.textColor = [UIColor darkGrayColor];
        _replyLabel.numberOfLines = 0;
        [self addSubview:_replyLabel];
        
        _headerView = [[UIView alloc]init];
        [self addSubview:_headerView];
        
        _thumbUpLabel = [[UILabel alloc]init];
        _thumbUpLabel.font = kOrderListCellFont;
        _thumbUpLabel.textColor = [UIColor darkGrayColor];
        _thumbUpLabel.numberOfLines = 0;
        [self addSubview:_thumbUpLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _replyLabel.frame = _contenFrame.replyFrame;
    _bgView.frame = _contenFrame.bgFrame;
    _headerView.frame = _contenFrame.headerFrame;
    _thumbUpLabel.frame = _contenFrame.thumbUpFrame;
}
- (void)setContenFrame:(CPPileEvalutionContentFrame *)contenFrame
{
    _contenFrame = contenFrame;
    NSString *contentString = @"";
    for(int i = 0;i < _contenFrame.replyModel.replyArray.count;i++)
    {
        CPPileEvalutionModel *replyModel = _contenFrame.replyModel.replyArray[i];
        contentString = [contentString stringByAppendingString:[NSString stringWithFormat:@"%@：%@",replyModel.userName,replyModel.content]];
        if(i != _contenFrame.replyModel.replyArray.count -1)
        {
            contentString = [contentString stringByAppendingString:@"\n"];
        }
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    for(int i = 0;i < _contenFrame.replyModel.replyArray.count;i++)
    {
        CPPileEvalutionModel *replyModel = _contenFrame.replyModel.replyArray[i];
        NSString *nameString = [NSString stringWithFormat:@"%@：",replyModel.userName];
        NSString *allString = [NSString stringWithFormat:@"%@：%@",replyModel.userName,replyModel.content];
        NSRange nameRange = [contentString rangeOfString:allString];
        [str addAttribute:NSForegroundColorAttributeName value:[ColorConfigure globalGreenColor] range:NSMakeRange(nameRange.location,[nameString length])];
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpacing];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    [str addAttribute:NSFontAttributeName value:kOrderListCellFont range:NSMakeRange(0, [str length])];

    [_replyLabel sizeToFit];
    _replyLabel.attributedText = str;
    
    NSString *thumbupString = @"";
    if(_contenFrame.replyModel.thumbupArray.count > 0)
    {
        thumbupString = @"♡  ";
    }
    for(int i = 0;i < _contenFrame.replyModel.thumbupArray.count;i++)
    {
        CPPileEvalutionModel *replyModel = _contenFrame.replyModel.thumbupArray[i];
        thumbupString = [thumbupString stringByAppendingString:replyModel.userName];
        if(i != _contenFrame.replyModel.thumbupArray.count - 1)
        {
            thumbupString = [thumbupString stringByAppendingString:@"，"];
        }
    }
    _thumbUpLabel.text = thumbupString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
