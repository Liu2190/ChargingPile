//
//  CPDynamicBannerTableViewCell.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBannerHeight 200.0f
@protocol HomeBannerDelegate <NSObject>
- (void)homeBannerViewDidClick:(NSString *)webViewUrl;

@end
@interface CPDynamicBannerTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)id <HomeBannerDelegate>delegate;
@property (nonatomic,assign)CGFloat timeInterval;
@property (nonatomic,strong)NSMutableArray *imagesArray;
@end

