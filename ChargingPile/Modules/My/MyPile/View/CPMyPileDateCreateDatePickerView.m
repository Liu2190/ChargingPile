//
//  CPMyPileDateCreateDatePickerView.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDateCreateDatePickerView.h"
#import "ColorConfigure.h"
#import "CommonMethod.h"

#define kBgViewHeight 197
@interface CPMyPileDateCreateDatePickerView ()<UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    DatePickerBlock privateBlock;
    UIView *bgView;
    NSInteger selectIndex;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIPickerView *pilePickerView;

@end
@implementation CPMyPileDateCreateDatePickerView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (CPMyPileDateCreateDatePickerView *)sharedInstance
{
    static dispatch_once_t onceToken;
    static CPMyPileDateCreateDatePickerView *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[CPMyPileDateCreateDatePickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.dataArray = [[NSMutableArray alloc]init];
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kBgViewHeight)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        self.pilePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kBgViewHeight - 162, kScreenWidth, 162)];
        self.pilePickerView.delegate = self;
        self.pilePickerView.dataSource = self;
        self.pilePickerView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:self.pilePickerView];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        NSArray *titleArray = @[@"取消",@"确定"];
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.frame = CGRectMake(i*(frame.size.width - 46), 0, 46, 30);
            [bgView addSubview:titleButton];
            [titleButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [titleButton setTitleColor:[ColorConfigure globalGreenColor] forState:UIControlStateNormal];
            titleButton.tag = i;
            [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [bgView addSubview:titleButton];
        }
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)buttonClick:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [self tappedCancel];
    }
    else
    {
        [self confirmAction];
    }
}
- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [bgView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), self.frame.size.width, kBgViewHeight)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (void)confirmAction
{
    privateBlock([self.pilePickerView selectedRowInComponent:0]);
    [self tappedCancel];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id member  =  [self.dataArray objectAtIndex:row];
    if([member isKindOfClass:[NSString class]])
    {
        return member;
    }
    else if ([member isKindOfClass:[CPPileStationListModel class]])
    {
        CPPileStationListModel *model = (CPPileStationListModel *)member;
        return model.name;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectIndex = row;
}
- (void)showPickerViewArray:(NSMutableArray *)datas andSelectIndex:(NSInteger)sIndex andBlock:(DatePickerBlock)block
{
    privateBlock = block;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:datas];
    selectIndex = sIndex;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
         [bgView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-kBgViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), kBgViewHeight)];
     }completion:^(BOOL finished)
     {
         [self.pilePickerView reloadAllComponents];
         [self.pilePickerView selectRow:selectIndex inComponent:0 animated:NO];
         [self pickerView:self.pilePickerView didSelectRow:selectIndex inComponent:0];
     }];
}
@end
