//
//  CPDynamicDetailViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicDetailViewController.h"
#import "CPDynamicListModel.h"

#import "MWPhotoBrowser.h"

#import "CPDynamicBannerTableViewCell.h"
#import "CPDynamicDetailTitleTableViewCell.h"
#import "CPDynamicDetailContentTableViewCell.h"

#import "ServerAPI.h"

@interface CPDynamicDetailViewController ()<MWPhotoBrowserDelegate,UINavigationControllerDelegate>
{
    CPDynamicListModel *contentModel;
}
@end

@implementation CPDynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态详情";
    [self getDetailData];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [CPDynamicDetailTitleTableViewCell cellHeightWith:contentModel.title andTime:contentModel.createTime];
    }
    else if (indexPath.row == 1)
    {
        return kBannerHeight;
    }
    else if (indexPath.row == 2)
    {
       return [CPDynamicDetailContentTableViewCell cellHeightWith:contentModel.content];
    }
    return 100.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CPDynamicDetailTitleTableViewCell *cell = [CPDynamicDetailTitleTableViewCell cellWithTableView:tableView];
        [cell setCellContent:contentModel.title andTime:contentModel.createTime];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        CPDynamicBannerTableViewCell *cell = [CPDynamicBannerTableViewCell cellWithTableView:tableView];
        if(self.dataArray.count > 0)
        {
            MWPhoto *photo = self.dataArray[0];
            cell.imagesArray = (NSMutableArray *)@[@{@"img":[NSString stringWithFormat:@"%@",photo.photoURL]}];
        }
        return cell;
    }
    else if (indexPath.row == 2)
    {
        CPDynamicDetailContentTableViewCell *cell = [CPDynamicDetailContentTableViewCell cellWithTableView:tableView];
         [cell setCellContent:contentModel.content];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        [self bannerViewDidClick];
    }
}
#pragma mark - 图片放大缩小
- (void)bannerViewDidClick
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
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:browser];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.dataArray.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.dataArray.count)
        return [self.dataArray objectAtIndex:index];
    return nil;
}
- (void)getDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/news/api/%@",kServerHost,self.dynamicId];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"成功 = %@",responseObj);
         contentModel = [[CPDynamicListModel alloc]initWith:responseObj];
         MWPhoto *photo;
         photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/news/api/image/%@",kServerHost,contentModel.dynamicId]]];
         [self.dataArray addObject:photo];
         [self.tableView reloadData];
     }failure:^(NSError *error)
     {
         NSLog(@"失败 = %@",error);
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
