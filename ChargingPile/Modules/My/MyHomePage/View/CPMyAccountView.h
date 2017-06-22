//
//  CPMyAccountView.h
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

#define kCPMyAccountViewHeight 160
typedef NS_ENUM(NSInteger,CPMyAccountViewType) {
    CPMyAccountViewMy,//我的页面
    CPMyAccountViewTypeDetail,//我的账户页面
};
@interface CPMyAccountView : UIView
@property (nonatomic,strong)UIImageView *accountImageView;
@property (nonatomic,strong)UILabel *accountNameLabel;
@property (nonatomic,assign)CPMyAccountViewType sourceType;
- (void)setAccountImageWith:(UIImage *)image;
- (void)changeSubviewsFrame;
@end
