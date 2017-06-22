//
//  CPMyPileDetailTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMyPileDetailTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *infoTextLabel;
@property (nonatomic,strong)UITextField *infoTextField;
@property (nonatomic,strong)UILabel *unitLabel;
@property (nonatomic,strong)NSString *unitString;
@property (nonatomic,strong)UILabel *moneyIconLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWith:(NSString *)name withArrowHidden:(BOOL)isHidden;
- (void)setCellWithName:(NSString *)name andTextFiled:(NSString *)text andPlaceHolder:(NSString *)placeHolder andArrowIsHidden:(BOOL)isHidden;
- (void)setMoneyIconLabelFrame;
@end
