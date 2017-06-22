//
//  CPPublishEvalutionViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPublishEvalutionViewController.h"
#import "CPFindPileServer.h"

#define kTableFooterViewHeight 70
#define kTableCellHeight 200

#define kPlaceHolder @"请输入信息"
@interface CPPublishEvalutionViewController ()<UITextViewDelegate>
{
    UILabel *placeHolder;
    UITextView *tv;
    UIButton *inquireButton;
}

@end

@implementation CPPublishEvalutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self setFooterView];
    [self setupPlaceHolderView];
    [self textViewDidChange:tv];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [tv becomeFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = tableView.backgroundColor;
    for(UIView *subview in [cell subviews])
    {
        if([subview isKindOfClass:[UITextView class]])
        {
            [subview removeFromSuperview];
        }
    }
    tv = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20,kTableCellHeight - 20)];
    tv.backgroundColor = [UIColor whiteColor];
    tv.font = [UIFont systemFontOfSize:15];
    tv.textColor = [UIColor darkGrayColor];
    [tv addSubview:placeHolder];
    tv.userInteractionEnabled = YES;
    tv.delegate = self;
    [cell addSubview:tv];
    return cell;
}
- (void)setFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 20, kScreenW - 30, 45);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"确定" forState:UIControlStateNormal];
    inquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}
- (void)commentAction
{
    NSLog(@"输入内容= %@",tv.text);
    NSString *replaceString = [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(replaceString.length < 1)
    {
        [MBProgressHUD showError:@"请输入内容"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    BOOL isreplay = self.sourceType == CPPublishEvalutionViewControllerTypeComment?NO:YES;
    NSString *StationId = self.sourceType == CPPublishEvalutionViewControllerTypeComment?[self.pileModel.pileId mutableCopy]:@"";
    NSString *CommentId = self.sourceType == CPPublishEvalutionViewControllerTypeComment?@"":[self.commentModel.evalutionId mutableCopy];
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doAddPileCommentWithIsReply:isreplay andStationId:StationId andCommentId:CommentId andTypes:1 andContent:replaceString andSuccessCallback:^(NSDictionary *callback)
     {
         [MBProgressHUD hideHUD];
         if([[callback objectForKey:@"state"] intValue] == 0)
         {
             [MBProgressHUD showSuccess:@"评论成功"];
             [self.navigationController dismissViewControllerAnimated:YES completion:^(void)
             {
                 [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCommentSuccess object:nil];
             }];
         }
         else
         {
             [MBProgressHUD showError:@"评论失败"];
         }
     }andFailureCallback:^(NSString *error)
     {
         [MBProgressHUD hideHUD];
         NSLog(@"获取失败 = %@",error);
     }];
}
- (void)setupPlaceHolderView
{
    placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(4, 5, kScreenWidth, 20)];
    placeHolder.textColor = [UIColor lightGrayColor];
    placeHolder.font = [UIFont systemFontOfSize:15];
    placeHolder.text = @"请输入信息";
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHolder.hidden = YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    placeHolder.hidden = (textView.text.length == 0?NO:YES);
    inquireButton.enabled = placeHolder.hidden;
    inquireButton.alpha = placeHolder.hidden?1:0.8;
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
