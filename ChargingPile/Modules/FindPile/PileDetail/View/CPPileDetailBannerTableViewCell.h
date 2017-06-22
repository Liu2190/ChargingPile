//
//  CPPileDetailBannerTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/10/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBannerHeight 200.0f
@protocol CPPileDetailBannerTableViewCellDelegate <NSObject>

- (void)bannerViewDidClick:(int )index;

@end
@interface CPPileDetailBannerTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
@property (nonatomic,assign)id <CPPileDetailBannerTableViewCellDelegate>delegate;
@property (nonatomic,assign)CGFloat timeInterval;
@property (nonatomic,strong)NSMutableArray *imagesArray;
@property (nonatomic,strong)UIButton *collectButton;
@end

