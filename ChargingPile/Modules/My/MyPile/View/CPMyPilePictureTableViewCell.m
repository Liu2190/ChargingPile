//
//  CPMyPilePictureTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPilePictureTableViewCell.h"
#import "CommonDefine.h"
#import "UIImageView+WebCache.h"
#import "MWPhoto.h"

#define kImageWidth 64.0f
#define kImageVerticalSpace 15.0f
#define kImageHorizontalSpace 17.0f

#define kCellTitleHight 48.0f

@implementation CPMyPilePictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPMyPilePictureTableViewCellIdentifier";
    CPMyPilePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPMyPilePictureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 48)];
        self.imageTitleLabel.text = @"上传图片";
        self.imageTitleLabel.font = [UIFont systemFontOfSize:14];
        self.imageTitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.imageTitleLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (CGFloat)cellHight
{
    int row = (kScreenWidth - kImageHorizontalSpace * 2.0)/kImageWidth;
    int column = kImageMaxCount % row > 0? (kImageMaxCount / row +1):kImageMaxCount / row ;
    return column *(kImageWidth + kImageVerticalSpace) + kCellTitleHight;
}
- (void)setupSubviewsWithArray:(NSMutableArray *)imageArray
{
    self.imageTitleLabel.text = [NSString stringWithFormat:@"电桩图片 %d/%d",(int)imageArray.count,kImageMaxCount];

    int row = (kScreenWidth - kImageHorizontalSpace * 2.0)/kImageWidth;
    int column = kImageMaxCount % row > 0? (kImageMaxCount / row +1):kImageMaxCount / row ;
    CGFloat imageSpace = (kScreenWidth - kImageHorizontalSpace * 2.0 - kImageWidth *row)/(row - 1);
    for(int i = 0 ;i < column;i++)
    {
        for(int j = 0;j < row;j++)
        {
            int tag = i * row + j;
            if(tag > kImageMaxCount)
            {
                return;
            }
            CGFloat imageY = i *(kImageWidth + kImageVerticalSpace) + kCellTitleHight;
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(kImageHorizontalSpace + (imageSpace + kImageWidth)*j, imageY, kImageWidth, kImageWidth);
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.tag = tag;
            [self addSubview:imageView];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
            [imageView addGestureRecognizer:gesture];
            if(tag < imageArray.count)
            {
                id member = imageArray[tag];
                if([member isKindOfClass:[UIImage class]])
                {
                    imageView.image = (UIImage *)member;
                }
                if([member isKindOfClass:[MWPhoto class]])
                {
                    MWPhoto *photo = (MWPhoto *)member;
                    if(photo.image != nil)
                    {
                        imageView.image = photo.image;
                    }
                    else if (photo.photoURL != nil)
                    {
                        [imageView sd_setImageWithURL:photo.photoURL];
                    }
                }
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"添加照片"];
            }
        }
    }
}
- (void)selectImage:(UIGestureRecognizer *)sender
{
    if(self.delegate)
    {
        [self.delegate selectImageWith:sender.view.tag];
    }
}

@end

