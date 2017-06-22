//
//  CPPileEvalutionListViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/30.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileEvalutionListViewController.h"
#import "CPPublishEvalutionViewController.h"
#import "CPNavigationController.h"

#import "CPPileEvaHeaderTableViewCell.h"
#import "CPPileEvalutionTitleCell.h"
#import "CPPileEvalutionContentCell.h"

#import "CPFindPileServer.h"
#import "MJRefresh.h"
#import "NSDictionary+Additions.h"
#import "CMPAccount.h"
#import "ServerAPI.h"

@interface CPPileEvalutionListViewController ()
{
    CPPileEvaHeaderFrame *frame1;
    int pageNum,pageCount;
}

@end

@implementation CPPileEvalutionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:kNotificationCommentSuccess object:nil];
    self.title = self.sourceType == CPPileEvalutionModelTypePile? @"所有评价":@"我的评价";
    frame1 = [[CPPileEvaHeaderFrame alloc]init];
    frame1.listModel = self.pileModel;
    pageNum = pageCount = 1,
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
    self.tableView.separatorColor = [UIColor clearColor];
    [self refreshAction];
    // Do any additional setup after loading the view.
}
- (void)refreshAction
{
    pageNum = 1;
    [self getDataWith:pageNum];
}
- (void)addMoreAction
{
    if(pageNum < pageCount)
    {
        pageNum ++;
        [self getDataWith:pageNum];
    }
    else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.sourceType == CPPileEvalutionModelTypePile)
    {
        return self.dataArray.count + 1;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.sourceType == CPPileEvalutionModelTypePile)
    {
        return section == 1?40.0:0.01;
    }
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 && self.sourceType == CPPileEvalutionModelTypePile)
    {
        return 1;
    }
    NSInteger index = self.sourceType == CPPileEvalutionModelTypePile?(section -1):section;
    CPPileEvalutionTitleFrame *titleFrame = [self.dataArray[index] firstObject];
    CPPileEvalutionModel *model = titleFrame.listModel;
    return (model.replyArray.count>0 || model.thumbupArray.count>0)?2:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = self.sourceType == CPPileEvalutionModelTypePile?(indexPath.section -1):indexPath.section;
    if(indexPath.section == 0 && self.sourceType == CPPileEvalutionModelTypePile)
    {
        return frame1.cellHeight;
    }
    else if (indexPath.row == 0)
    {
        CPPileEvalutionTitleFrame *titleFrame = [self.dataArray[section] firstObject];
        return titleFrame.cellHeight;
    }
    else if (indexPath.row == 1)
    {
        if([self.dataArray[section] count]> 1)
        {
            CPPileEvalutionContentFrame *contentFrame = [self.dataArray[section] lastObject];
            return contentFrame.cellHeight;
        }
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = self.sourceType == CPPileEvalutionModelTypePile?(indexPath.section -1):indexPath.section;
    if(indexPath.section == 0 && self.sourceType == CPPileEvalutionModelTypePile)
    {
        CPPileEvaHeaderTableViewCell *cell = [CPPileEvaHeaderTableViewCell cellWithTableView:tableView];
        cell.headerFrame = frame1;
        return cell;
    }
    else if (indexPath.row == 0)
    {
        CPPileEvalutionTitleCell *cell = [CPPileEvalutionTitleCell cellWithTableView:tableView];
        CPPileEvalutionTitleFrame *titleF = [self.dataArray[section] firstObject];
        cell.titleFrame = titleF;
        cell.deleteButton.tag = section;
        cell.thumbUpButton.tag = section;
        cell.commentButton.tag = section;
        [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.thumbUpButton setTitle:[NSString stringWithFormat:@"%d",(int)titleF.listModel.thumbupArray.count] forState:UIControlStateNormal];
        [cell.thumbUpButton addTarget:self action:@selector(thumbUpAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        CPPileEvalutionContentCell *cell = [CPPileEvalutionContentCell cellWithTableView:tableView];
        CPPileEvalutionContentFrame *contentFrame = [self.dataArray[section] lastObject];
        cell.contenFrame = contentFrame;
        return cell;
    }
    return nil;
}
- (void)getDataWith:(int)currentPage
{
    NSString *urlStr = [[NSString alloc]init];
    if(self.sourceType == CPPileEvalutionModelTypePile)
    {
        urlStr = [NSString stringWithFormat:@"%@%@%@?page=%d",kServerHost,@"rest/station/api/comments/",self.pileModel.pileId,currentPage];
    }
    else
    {
         urlStr = [NSString stringWithFormat:@"%@rest/station/api/mycmts/%@?page=%d",kServerHost,[CMPAccount sharedInstance].accountInfo.uid,currentPage];
    }
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         if([[responseObj objectForKey:@"state"] intValue] == 0)
         {
             pageCount = [[responseObj objectForKey:@"count"] intValue];
             
             if(currentPage == 1)
             {
                 [self.dataArray removeAllObjects];
             }
             for(NSDictionary *member in [responseObj objectForKey:@"list"])
             {
                 CPPileEvalutionModel *commentModel = [[CPPileEvalutionModel alloc]initWithDict:member];
                 commentModel.type = self.sourceType;
                 [commentModel deleteRepeatThumbup];
                 CPPileEvalutionTitleFrame *titleFrame = [[CPPileEvalutionTitleFrame alloc]init];
                 titleFrame.listModel = commentModel;
                 CPPileEvalutionContentFrame *contentFrame = [[CPPileEvalutionContentFrame alloc]init];
                 contentFrame.replyModel = commentModel;
                 [self.dataArray addObject:@[titleFrame,contentFrame]];
             }
             [MBProgressHUD hideHUD];
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshing];
             [self.tableView.mj_header endRefreshing];
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_header endRefreshing];
     }];
}
#pragma mark - 删除
- (void)deleteAction:(UIButton *)sender
{
    [MBProgressHUD showMessage:@""];
    CPPileEvalutionTitleFrame *titleF = [self.dataArray[sender.tag] firstObject];
    CPPileEvalutionModel *listModel = titleF.listModel;
    
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doDeletePileCommentWithId:listModel.evalutionId andSuccessCallback:^(NSDictionary *callback)
     {
         NSLog(@"删除电站评论 = %@",callback);
         [self refreshData];
     }andFailureCallback:^(NSError *error)
     {
         NSLog(@"获取失败 = %@",error);
     }];
}

- (void)refreshData
{
    [self.dataArray removeAllObjects];
    [self getDataWith:pageNum];
}
#pragma mark - 赞
- (void)thumbUpAction:(UIButton *)sender
{
    CPPileEvalutionTitleFrame *titleF = [self.dataArray[sender.tag] firstObject];
    CPPileEvalutionModel *listModel = titleF.listModel;
    if([listModel.thumbupUserIdArray containsObject:[CMPAccount sharedInstance].accountInfo.uid])
    {
        //取消
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < listModel.thumbupEvalutionIdArray.count;i++)
        {
            if([listModel.thumbupUserIdArray[i] isEqualToString: [CMPAccount sharedInstance].accountInfo.uid])
            {
                [tempArray addObject:[listModel.thumbupEvalutionIdArray[i] mutableCopy]];
            }
        }
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [sender.layer addAnimation:k forKey:@"SHOW"];
        if([[sender currentTitle] intValue] > 0)
        {
            int title = [[sender currentTitle] intValue] - 1;
            [sender setTitle:[NSString stringWithFormat:@"%d",title] forState:UIControlStateNormal];
        }
        [MBProgressHUD showMessage:@""];
        for(int i = 0;i<tempArray.count;i++)
        {
            NSString *evalutionId = tempArray[i];
            [[ServerFactory getServerInstance:@"CPFindPileServer"]doDeletePileCommentWithId:evalutionId andSuccessCallback:^(NSDictionary *callback)
             {
                 NSLog(@"删除电站评论 = %@",callback);
                 if(i == tempArray.count-1)
                 {
                     [self refreshData];
                 }
             }andFailureCallback:^(NSError *error)
             {
                 NSLog(@"获取失败 = %@",error);
             }];
        }
    }
    else
    {
        //点
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [sender.layer addAnimation:k forKey:@"SHOW"];
        int title = [[sender currentTitle] intValue] + 1;
        [sender setTitle:[NSString stringWithFormat:@"%d",title] forState:UIControlStateNormal];
        BOOL isreplay = YES;
        NSString *StationId = @"";
        NSString *CommentId = [listModel.evalutionId mutableCopy];
        [MBProgressHUD showMessage:@""];
        [[ServerFactory getServerInstance:@"CPFindPileServer"]doAddPileCommentWithIsReply:isreplay andStationId:StationId andCommentId:CommentId andTypes:0 andContent:@"" andSuccessCallback:^(NSDictionary *callback)
         {
             if([[callback objectForKey:@"state"] intValue] == 0)
             {
                 [self refreshData];
             }
         }andFailureCallback:^(NSString *error)
         {
             [MBProgressHUD hideHUD];
             NSLog(@"获取失败 = %@",error);
         }];
    }
}
#pragma mark - 评论
- (void)commentAction:(UIButton *)sender
{
    CPPileEvalutionTitleFrame *titleF = [self.dataArray[sender.tag] firstObject];
    CPPileEvalutionModel *listModel = titleF.listModel;
    CPPublishEvalutionViewController *pubVC = [[CPPublishEvalutionViewController alloc]init];
    pubVC.commentModel = listModel;
    pubVC.sourceType = CPPublishEvalutionViewControllerTypeReply;
    CPNavigationController *nav = [[CPNavigationController alloc]initWithRootViewController:pubVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
