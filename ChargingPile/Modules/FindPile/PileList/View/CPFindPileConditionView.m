//
//  CPFindPileConditionView.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/26.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileConditionView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "CPPlieModel.h"

#define kCPFindPileConditionViewCellHeight 42.0f
@interface CPFindPileConditionView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *ruleTableView;
    CPFindPileConditionViewBlock _block;
    NSMutableArray *dataArray;
    int selectIndex;
}
@end

@implementation CPFindPileConditionView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (CPFindPileConditionView *)sharedInstance
{
    static CPFindPileConditionView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [[CPFindPileConditionView alloc]initWithFrame:CGRectMake(0, kCPPileListHeaderViewHeight + 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - kCPPileListHeaderViewHeight - 64)];
        }
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        dataArray = [[NSMutableArray alloc]init];
        [dataArray addObjectsFromArray:@[@"123",@"123",@"321",@"345"]];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        ruleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100) style:UITableViewStylePlain];
        ruleTableView.delegate = self;
        ruleTableView.dataSource = self;
        [self addSubview:ruleTableView];
    }
    return self;
}

- (void)showViewWith:(NSArray *)reasonArray andSelectIndex:(int)index andBlock:(CPFindPileConditionViewBlock)block
{
    _block = block;
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:reasonArray];
    selectIndex = index;
    [ruleTableView reloadData];
    if(![self isDescendantOfView:[[UIApplication sharedApplication]keyWindow]])
    {
        [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    }
    [UIView animateWithDuration:0.25f animations:^
     {
        ruleTableView.height = kCPFindPileConditionViewCellHeight * dataArray.count;
     }completion:^(BOOL finished)
     {
     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return YES;
}
- (void)tappedCancel
{
    [UIView animateWithDuration:0.1f delay:0.001 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.backgroundColor = [UIColor clearColor];
        // [ruleTableView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 150)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCPFindPileConditionViewCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CPFindPileConditionViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if([dataArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        cell.textLabel.text = dataArray[indexPath.row];
    }
    else if ([dataArray[indexPath.row] isKindOfClass:[CPPlieModel class]])
    {
        CPPlieModel *model = dataArray[indexPath.row];
        cell.textLabel.text = model.name;
    }
    for(UIImageView *subView in [cell subviews])
    {
        if([subView isKindOfClass:[UIImageView class]])
        {
            [subView removeFromSuperview];
        }
    }
    if (selectIndex == indexPath.row)
    {
        UIImageView *cellImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeSelect"]];
        cellImage.centerY = 22.0f;
        cellImage.centerX = kScreenW - 40;
        [cell addSubview:cellImage];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = (int)indexPath.row;
    [ruleTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        _block (selectIndex);
        [self tappedCancel];
    });
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)viewDidLayoutSubviews
{
    if ([ruleTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [ruleTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([ruleTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [ruleTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

@end
