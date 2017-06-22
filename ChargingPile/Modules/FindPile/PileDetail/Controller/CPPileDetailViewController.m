//
//  CPPileDetailViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileDetailViewController.h"
#import "CPPublishEvalutionViewController.h"
#import "CPPileEvalutionListViewController.h"
#import "CPNavigationController.h"
#import "MWPhotoBrowser.h"

#import "CPPileDetailInfoTableViewCell.h"
#import "CPPileDetailBannerTableViewCell.h"
#import "CPPileDetailCommentView.h"
#import "CPRatingBar.h"

#import "MapCommonUtility.h"
#import "CPFindPileServer.h"
#import "ServerAPI.h"

#import "CPPileEvalutionModel.h"

#define kTitleKey @"titleKey"
#define kContentKey @"contentKey"

@interface CPPileDetailViewController ()<CPPileDetailBannerTableViewCellDelegate,MWPhotoBrowserDelegate,UINavigationControllerDelegate>
{
    CPPileDetailCommentView *footerView;
    int totalCount;
}
@property (nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation CPPileDetailViewController

- (NSMutableArray *)imageArray
{
    if(!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.pileModel.name;
    [self setFooterViewWithHeight:130];
    [self setData];
    MWPhoto *photo;
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/station/icon/%@",kServerHost,self.pileModel.pileId]]];
    [self.imageArray addObject:photo];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPileComments];
}
- (void)setData
{
    NSString *price = @"";
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:[NSDate date]];
    NSInteger thisHour = [currentComps hour];
    if((thisHour >= 7 &&thisHour < 8)||(thisHour >= 11 &&thisHour < 15)||(thisHour >= 22 &&thisHour < 23))
    {
        price = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.ping];
    }
    else if(thisHour >= 19 &&thisHour < 22)
    {
        price = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.feng];
    }
    else if((thisHour >= 8 &&thisHour < 11)||(thisHour >= 15 &&thisHour < 19))
    {
        price = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.jian];
    }
    else
    {
        price = [NSString stringWithFormat:@"¥%@/kWh",_pileModel.gu];
    }
    if(self.sourceType == CPPileDetailVCTypeFavor)
    {
        price = @"";
    }
    [self.dataArray addObject:@[@{kTitleKey:@"key",kContentKey:@"value"},@{kTitleKey:@"公共站离网",kContentKey:price},@{kTitleKey:self.pileModel.address,kContentKey:self.pileModel.distanceAppearance},@{kTitleKey:@"",kContentKey:[NSString stringWithFormat:@"直流桩%@ 交流桩%@ 直流空闲%@ 交流空闲%@",self.pileModel.zhiLiu,self.pileModel.jiaoLiu,self.pileModel.idleZhiLiu,self.pileModel.idleJiaLiu]}]];
    [self.dataArray addObject:@[@{kTitleKey:@"电站描述",kContentKey:@"竭诚为您服务"},@{kTitleKey:@"站点类型",kContentKey:self.pileModel.dianzhanType},/*@{kTitleKey:@"开放时间",kContentKey:@"暂无"},@{kTitleKey:@"计费方式",kContentKey:@"暂无"}*/]];
    [self.dataArray addObject:@[@{kTitleKey:@"功能区",kContentKey:@"暂无"},@{kTitleKey:@"便利设施",kContentKey:@"暂无"}]];
    [self.dataArray addObject:@[@{kTitleKey:@"运营商",kContentKey:self.pileModel.operatorName}]];
    [self.dataArray addObject:@[@{kTitleKey:@"key",kContentKey:@"value"}]];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        return [CPPileDetailBannerTableViewCell cellHeight];
    }
    return 50.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0.001:10.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        CPPileDetailBannerTableViewCell *cell = [CPPileDetailBannerTableViewCell cellWithTableView:tableView];
        cell.imagesArray = self.imageArray;
        cell.delegate = self;
        NSString *imageName = self.pileModel.isFavor?@"收藏-拷贝":@"收藏";
        [cell.collectButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [cell.collectButton addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.section == 4 && indexPath.row == 0)
    {
        CPPileDetailInfoTableViewCell *cell = [CPPileDetailInfoTableViewCell cellWithTableView:tableView];
        cell.titleLabel.text = @"电站评价";
        cell.contentLabel.hidden = YES;
        for(CPRatingBar *imageView in [cell subviews])
        {
            if([imageView isKindOfClass:[CPRatingBar class]])
            {
                [imageView removeFromSuperview];
            }
        }
        CPRatingBar *ratingBar = [[CPRatingBar alloc]initWithFrame:CGRectMake(100, 0, 80, 20)];
        ratingBar.centerY = 25.0f;
        ratingBar.rateValue = [self.pileModel.star floatValue];
        [cell addSubview:ratingBar];
        return cell;
    }
    else
    {
        CPPileDetailInfoTableViewCell *cell = [CPPileDetailInfoTableViewCell cellWithTableView:tableView];
        if([self.dataArray objectAtIndex:indexPath.section] !=nil)
        {
            NSDictionary *dict = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = dict[kTitleKey];
            cell.contentLabel.text = dict[kContentKey];
        }
        return cell;
    }
    return nil;
}
- (void)setFooterViewWithHeight:(CGFloat)height
{
    footerView = nil;
    self.tableView.tableFooterView = nil;
    footerView = [[CPPileDetailCommentView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, height)];
    [footerView.moreButton addTarget:self action:@selector(moreCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView.moreButton setTitle:[NSString stringWithFormat:@"更多评论（%d条）",totalCount] forState:UIControlStateNormal];
    [footerView.button1 addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView.button2 addTarget:self action:@selector(navAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
}
#pragma mark - 评论
- (void)commentAction
{
    CPPublishEvalutionViewController *pubVC = [[CPPublishEvalutionViewController alloc]init];
    pubVC.pileModel = self.pileModel;
    pubVC.sourceType = CPPublishEvalutionViewControllerTypeComment;
    CPNavigationController *nav = [[CPNavigationController alloc]initWithRootViewController:pubVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 图片放大缩小
- (void)bannerViewDidClick:(int )index
{
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL showRightBarButton = NO;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.showRightBarButton = showRightBarButton;
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = enableGrid;//是否全屏,默认是
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:index];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:browser];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imageArray.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.imageArray.count)
        return [self.imageArray objectAtIndex:index];
    return nil;
}

#pragma mark - 导航
- (void)navAction
{
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([self.pileModel.lat doubleValue], [self.pileModel.lng doubleValue]);
    [[MapCommonUtility sharedInstance]showNavigationSheetWithCurrentLocation:self.currentLocation andDestinationLocaiton:destination andDestinationTitle:self.pileModel.name];
}
#pragma mark - 更多评论
- (void)moreCommentAction
{
    CPPileEvalutionListViewController *eVC = [[CPPileEvalutionListViewController alloc]init];
    eVC.pileModel = self.pileModel;
    eVC.sourceType = CPPileEvalutionModelTypePile;
    [self.navigationController pushViewController:eVC animated:YES];
}
#pragma mark - 收藏
- (void)collectAction
{
    [MBProgressHUD showMessage:@""];
    if(self.pileModel.isFavor)
    {
        //取消收藏

        [[ServerFactory getServerInstance:@"CPFindPileServer"]doRemoveFavorWithStationId:self.pileModel.pileId andSuccessCallback:^(NSDictionary *callback)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"取消收藏 = %@",callback);
             if([[callback objectForKey:@"state"] intValue] == 0)
             {
                 self.pileModel.isFavor = !self.pileModel.isFavor;
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD showError:@"取消收藏失败"];
             }
         }andFailureCallback:^(NSString *error)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"获取失败 = %@",error);
             [MBProgressHUD showError:@"取消收藏失败"];
         }];
    }
    else
    {
        //添加收藏
        [[ServerFactory getServerInstance:@"CPFindPileServer"]doAddFavorWithStationId:self.pileModel.pileId andSuccessCallback:^(NSDictionary *callback)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"添加收藏 = %@",callback);
             if([[callback objectForKey:@"state"] intValue] == 0)
             {
                 self.pileModel.isFavor = !self.pileModel.isFavor;
                 [self.tableView reloadData];
             }
             else
             {
                 [MBProgressHUD showError:@"添加收藏失败"];
             }
         }andFailureCallback:^(NSString *error)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"获取失败 = %@",error);
             [MBProgressHUD showError:@"添加收藏失败"];
         }];
    }
}
#pragma mark - 获取所有评论
- (void)getPileComments
{
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doGetPileCommentsWithStationId:self.pileModel.pileId andPageNum:1 andSuccessCallback:^(NSDictionary *callback)
     {
         NSLog(@"电站评论 = %@",callback);
         if([[callback objectForKey:@"state"] intValue] == 0)
         {
             totalCount = [[callback objectForKey:@"totalCount"] intValue];
             for(NSDictionary *member in [callback arrayValueForKey:@"list"])
             {
                 CPPileEvalutionModel *commentModel = [[CPPileEvalutionModel alloc]initWithDict:member];
                 commentModel.type = CPPileEvalutionModelTypePile;
                 [self setFooterViewWithHeight:kCPPileDetailCommentViewHeight];
                 [footerView setDataWith:commentModel];
                 break;
             }
         }
     }andFailureCallback:^(NSError *error)
     {
         NSLog(@"获取失败 = %@",error);
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
