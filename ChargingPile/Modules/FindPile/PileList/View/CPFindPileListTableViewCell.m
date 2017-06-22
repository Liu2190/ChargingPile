//
//  CPFindPileListTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/7.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileListTableViewCell.h"
#import "CommonDefine.h"
#import "ServerAPI.h"
#import "UIImageView+WebCache.h"
#import "CMPAccount.h"

#define kRightContentWidth 130.0

@implementation CPFindPileListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPFindPileListTableViewCellIdentifier";
    CPFindPileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPFindPileListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _listImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 170)];
        _listImageView.backgroundColor = [UIColor lightGrayColor];
        _listImageView.clipsToBounds = YES;
        _listImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_listImageView];
        
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.frame = CGRectMake(kScreenW - 100, 0, 100, 50);
        [_collectButton setImage:[UIImage imageNamed:@"收藏-拷贝"] forState:UIControlStateNormal];
        [self addSubview:_collectButton];

        UIImage *priceBgImage = [UIImage imageNamed:@"形状-17-副本"];
        _priceBg = [[UIImageView alloc]initWithImage:priceBgImage];
        _priceBg.x = 0;
        _priceBg.centerY = _listImageView.height - 20 - priceBgImage.size.height/2.0;
        [self addSubview:_priceBg];
    
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,_priceBg.width,_priceBg.height)];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.text = @"1000Am/H";
        [_priceBg addSubview:_priceLabel];
        

        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,_listImageView.height ,kScreenW - 10 - kRightContentWidth,kCPFindPileListTableViewCellHeight - _listImageView.height)];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_nameLabel];
        
        
        UIImage *logo = [UIImage imageNamed:@"品牌"];
        _logoImageView = [[UIImageView alloc]initWithImage:logo];
        _logoImageView.clipsToBounds = YES;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.centerY = _listImageView.height;
        _logoImageView.centerX = kScreenW - kRightContentWidth + kRightContentWidth/2.0;
        _logoImageView.layer.cornerRadius = logo.size.width/2.0;
        _logoImageView.layer.borderWidth = 3.0f;
        _logoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _logoImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_logoImageView];
        
        _ratingBar = [[CPRatingBar alloc]initWithFrame:CGRectMake(kScreenW - 100, CGRectGetMaxY(_logoImageView.frame), kCPRatingBarWidth, 20)];
        _ratingBar.centerX = _logoImageView.centerX;
        [self addSubview:_ratingBar];
        
        UIImage *ig1 = [UIImage imageNamed:@"公共站"];
        UIImage *ig2 = [UIImage imageNamed:@"导航"];
        _publicStationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publicStationButton.frame = CGRectMake(kScreenW - 180, 0, ig1.size.width, ig1.size.height);
        _publicStationButton.y = kCPFindPileListTableViewCellHeight - 15 - ig1.size.height;
        [_publicStationButton setImage:[UIImage imageNamed:@"公共站"] forState:UIControlStateNormal];
        [self addSubview:_publicStationButton];
        
        _navButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navButton.frame = CGRectMake(kScreenW - 90, 0, ig2.size.width, ig2.size.height);
        _navButton.centerY = _publicStationButton.centerY;
        [_navButton setImage:[UIImage imageNamed:@"导航"] forState:UIControlStateNormal];
        [self addSubview:_navButton];
    }
    return self;
}
- (void)setListModel:(CPPlieModel *)listModel
{
    _listModel = listModel;
    NSString *str1 = [NSString stringWithFormat:@"%@\n",_listModel.name];
    NSString *str2 = @"";
    if([listModel.idle intValue] > 0)
    {
        str2 = [NSString stringWithFormat:@"\n地址：%@\n",_listModel.address];
    }
    else
    {
        str2 = [NSString stringWithFormat:@"地址：%@\n",_listModel.address];
    }
    NSString *str3 = [NSString stringWithFormat:@"直流桩%@ 交流桩%@",_listModel.zhiLiu,_listModel.jiaoLiu];
    NSString *allString = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
    if([listModel.idle intValue] > 0)
    {
        UIImage *ig = [UIImage imageNamed:@"有空闲"];
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = ig;
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, ig.size.width, ig.size.height);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [str insertAttributedString:string atIndex:str1.length];
    }
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,[str1 length])];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    _nameLabel.attributedText = str;
    
  
    /*
     尖峰平谷分段电价表
     平峰时段
     7:00-8:00
     11:00-15:00
     22:00-23:00
     
     尖峰时段
     19:00-22:00
     
     高峰时段
     8:00-11:00 
     15:00-19:00 
     
     低谷时段
     23:00-次日7:00
     */
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:[NSDate date]];
    NSInteger thisHour = [currentComps hour];
    if((thisHour >= 7 &&thisHour < 8)||(thisHour >= 11 &&thisHour < 15)||(thisHour >= 22 &&thisHour < 23))
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_listModel.ping];
    }
    else if(thisHour >= 19 &&thisHour < 22)
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_listModel.feng];
    }
    else if((thisHour >= 8 &&thisHour < 11)||(thisHour >= 15 &&thisHour < 19))
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_listModel.jian];
    }
    else
    {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@/kWh",_listModel.gu];
    }
    
    _ratingBar.rateValue = [_listModel.star floatValue];
    [_listImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/station/icon/%@",kServerHost,listModel.pileId]] placeholderImage:[UIImage imageNamed:@"homePageTitle"]];
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,listModel.userId]] placeholderImage:[UIImage imageNamed:@"品牌"]];
    if(listModel.isFavor)
    {
        //收藏
        [_collectButton setImage:[UIImage imageNamed:@"收藏-拷贝"] forState:UIControlStateNormal];
    }
    else
    {
        [_collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
