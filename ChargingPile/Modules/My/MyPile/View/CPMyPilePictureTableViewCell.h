//
//  CPMyPilePictureTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kImageMaxCount 5

@protocol CPMyPilePictureCellDelegate;
@interface CPMyPilePictureTableViewCell : UITableViewCell
@property (nonatomic,assign)id< CPMyPilePictureCellDelegate>delegate;
@property (nonatomic,strong)UILabel *imageTitleLabel;
+ (CGFloat)cellHight;
- (void)setupSubviewsWithArray:(NSMutableArray *)array;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
@protocol CPMyPilePictureCellDelegate <NSObject>
- (void)selectImageWith:(NSInteger)index;
@end
