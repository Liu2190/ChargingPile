//
//  CPMyPileDateTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDateTableViewCell.h"
#import "ColorConfigure.h"

@implementation CPMyPileDateTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView;
{
    static NSString *identifier = @"CPMyPileDateTitleTableViewCellIdentifier";
    CPMyPileDateTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPMyPileDateTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _dateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, kCPMyPileDateTableViewCell1Height)];
        _dateTitleLabel.textColor = [ColorConfigure globalGreenColor];
        _dateTitleLabel.font = kOrderListCellFont;
        [self addSubview:_dateTitleLabel];
        
        UIImage *arrowI = [UIImage imageNamed:@"进入"];
        UIImageView *arrowIV = [[UIImageView alloc]initWithImage:arrowI];
        [self addSubview:arrowIV];
        arrowIV.centerY = kCPMyPileDateTableViewCell1Height/2.0;
        arrowIV.x = kScreenW - 13 - arrowI.size.width;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@interface CPMyPileDateContentTableViewCell ()
@property (nonatomic,strong)UILabel *timeLabel;

@end
@implementation CPMyPileDateContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView;
{
    static NSString *identifier = @"CPMyPileDateContentTableViewCellIdentifier";
    CPMyPileDateContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPMyPileDateContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW - 30, kCPMyPileDateTableViewCell2Height)];
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = kOrderListCellFont;
        [self addSubview:_timeLabel];
    }
    return self;
}
- (void)setDateModel:(CPPileDateModel *)dateModel
{
    _dateModel = dateModel;
    NSString *timeString = [NSString stringWithFormat:@"%@-%@",dateModel.beginTime,dateModel.endTime];
    NSArray *weekArray = [dateModel.days componentsSeparatedByString:@","];
    NSArray *weekTitle = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *weekString = @"";
    for(id member in weekArray)
    {
        NSString *string = [NSString stringWithFormat:@"%@",member];
        if(string.length < 1 || [string isEqualToString:@""]|| [string isEqualToString:@" "])
        {
            break;
        }
        int index = [string intValue]-1;
        NSString *title = weekTitle[index];

        weekString = [weekString stringByAppendingFormat:@"%@ ",title];
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@\n\n%@",timeString,weekString];
    /*
     days	周日到周六分别为1,2,3,4,5,6,7，中间用英文逗号分隔
     beginTime	开始时间
     endTime	结束时间
     */
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
