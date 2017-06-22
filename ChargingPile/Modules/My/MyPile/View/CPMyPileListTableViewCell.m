//
//  CPMyPileListTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileListTableViewCell.h"
#import "CommonDefine.h"
#import "ColorConfigure.h"
@interface CPMyPileListTableViewCell ()
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;

}
@end

@implementation CPMyPileListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPMyPileListTableViewCellIdentifier";
    CPMyPileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPMyPileListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, kScreenW - 30, kCPMyPileListTableViewCellHeight - 15)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 2.0f;
        [self addSubview:bgView];
        
        NSArray *titleArray = @[@"电桩名称",@"站点",@"位置",@"发布时间",@"审核状态"];
        float labelHeight = bgView.height/5.0;
        for(int i = 0;i < titleArray.count;i++)
        {
            NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
            attribute[NSFontAttributeName] = kOrderListCellFont;
            CGRect sumRect = [titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
            
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, labelHeight * i, sumRect.size.width, labelHeight)];
            tLabel.text = titleArray[i];
            tLabel.textColor = i == 0 ?[ColorConfigure globalGreenColor]:[UIColor darkGrayColor];
            tLabel.font = kOrderListCellFont;
            [bgView addSubview:tLabel];
            
            float cLabelX = CGRectGetMaxX(tLabel.frame) + 5;
            UILabel *cLabel = [[UILabel alloc]initWithFrame:CGRectMake(cLabelX, tLabel.y, bgView.width - 13 - cLabelX, tLabel.height)];
            cLabel.textColor = [UIColor darkGrayColor];
            cLabel.font = kOrderListCellFont;
            cLabel.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:cLabel];
            
            if(i != 4)
            {
                UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(tLabel.frame), bgView.width - 24, 0.3)];
                sepLine.backgroundColor = [UIColor lightGrayColor];
                [bgView addSubview:sepLine];
            }
            
            if(i == 0)
            {
                UIImage *arrowI = [UIImage imageNamed:@"进入"];
                UIImageView *arrowIV = [[UIImageView alloc]initWithImage:arrowI];
                [bgView addSubview:arrowIV];
                arrowIV.centerY = tLabel.centerY;
                arrowIV.x = bgView.width - 13 - arrowI.size.width;
                cLabel.width = cLabel.width - arrowIV.width;
                label1 = cLabel;
            }
            else if(i == 1)
            {
                label2 = cLabel;
            }
            else if(i == 2)
            {
                label3 = cLabel;
            }
            else if(i == 3)
            {
                label4 = cLabel;
            }
            else{
                label5 = cLabel;
            }
        }
    }
    return self;
}
- (void)setListModel:(CPMyPileListModel *)listModel
{
    _listModel = listModel;
    label1.text = listModel.pileName;
    label2.text = listModel.stationName;
    label3.text = listModel.address;
    label4.text = listModel.displayTime;
    label5.text = listModel.status;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
