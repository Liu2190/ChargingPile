//
//  CPPileDetailCommentTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/10/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileDetailCommentView.h"
#import "ServerAPI.h"
#import "UIImageView+WebCache.h"

@implementation CPPileDetailCommentView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)cellHeight
{
    return 130.0f;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 50, 50)];
        _headerImageView.clipsToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.cornerRadius = 25;
        [self addSubview:_headerImageView];
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 23, 200, 20)];
        _nameLabel.font = kOrderListCellFont;
        _nameLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 85, 16, 75, 20)];
        _timeLabel.font = kOrderListCellFont;
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        
        _evalutionLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(_nameLabel.frame) + 2, kScreenW - _nameLabel.x - 10, 40)];
        _evalutionLabel.font = kOrderListCellFont;
        _evalutionLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_evalutionLabel];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"更多评论" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _moreButton.frame = CGRectMake(80, 130 - 50, kScreenW - 160, 35);
        [self addSubview:_moreButton];
        _headerImageView.hidden = YES;
        _nameLabel.hidden = YES;
        _evalutionLabel.hidden = YES;
        _timeLabel.hidden = YES;
        _moreButton.hidden = YES;
        NSArray *titleArray = @[@"点评",@"导航"];
        for(int i = 0;i< titleArray.count;i++)
        {
            UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat space = (kScreenW - 2 * 90)/3.0;
            inquireButton.frame = CGRectMake(space + (space + 90) *i, 130, 90, 30);
            inquireButton.y = 70;
            inquireButton.layer.cornerRadius = 4.0f;
            [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
            [inquireButton setTitle:titleArray[i] forState:UIControlStateNormal];
            inquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:inquireButton];
            if(i == 0)
            {
                self.button1 = inquireButton;
            }
            else
            {
                self.button2 = inquireButton;
            }
        }
        for(UIView *subview in [self subviews])
        {
            subview.userInteractionEnabled = YES;
        }
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)setDataWith:(CPPileEvalutionModel *)model
{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,model.userId]]];
    _nameLabel.text = model.userName;
    
    _timeLabel.text = model.displayTime;
    
    _evalutionLabel.text = model.content;
    self.height = kCPPileDetailCommentViewHeight;
    _headerImageView.hidden = NO;
    _nameLabel.hidden = NO;
    _evalutionLabel.hidden = NO;
    _timeLabel.hidden = NO;
    _moreButton.hidden= NO;
    _button1.y = 130;
    _button2.y = 130;
}
@end
