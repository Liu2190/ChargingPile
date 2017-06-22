//
//  CPFindPileCityView.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPFindPileCityView.h"
#import "ColorConfigure.h"
#import "CommonMethod.h"
#import "FMDatabase.h"
#import "CPFindPileDBTool.h"

#define kInputBtnFont [UIFont systemFontOfSize:16]
#define kPickerContentFont [UIFont boldSystemFontOfSize:20]
#define kPickerRowH 45
#define kPickerH 275
#define kAnimateDuration 0.3

#define kBgViewHeight 197

@interface CPFindPileCityView ()<UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    CMPCityPickerViewBlock privateBlock;
    UIView *bgView;
}
@property (nonatomic,strong)UIPickerView *pilePickerView;
@property (nonatomic,strong)NSMutableArray *provinceArray;
@property (nonatomic,strong)NSMutableArray *cityArray;
@end
@implementation CPFindPileCityView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (CPFindPileCityView *)sharedInstance
{
    static dispatch_once_t onceToken;
    static CPFindPileCityView *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[CPFindPileCityView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.provinceArray = [[NSMutableArray alloc]init];
        self.cityArray = [[NSMutableArray alloc]init];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, [UIScreen mainScreen].bounds.size.width, kPickerH)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
        inputView.backgroundColor = [ColorUtility colorWithRed:247 green:248 blue:247];
        [bgView addSubview:inputView];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 60, inputView.height);
        cancelBtn.titleLabel.font = kInputBtnFont;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, inputView.height);
        sureBtn.titleLabel.font = kInputBtnFont;
        [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:sureBtn];
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:inputView.bounds];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.textColor = [UIColor blackColor];
        hintLabel.font = [UIFont boldSystemFontOfSize:17];
        hintLabel.text = @"地区";
        [inputView addSubview:hintLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake( 0, inputView.height -1, [UIScreen mainScreen].bounds.size.width, 1)];
        line.backgroundColor = [UIColor blackColor];
       // [inputView addSubview:line];
        
        self.pilePickerView = [[UIPickerView alloc]init];
        self.pilePickerView.frame = CGRectMake(0, inputView.height, [UIScreen mainScreen].bounds.size.width, bgView.height - inputView.height);
        self.pilePickerView.showsSelectionIndicator = YES;
        self.pilePickerView.delegate = self;
        self.pilePickerView.dataSource = self;
        self.pilePickerView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:self.pilePickerView];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self getAllData];
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
- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         [bgView setFrame:CGRectMake(0, kScreenH, kScreenW, kPickerH)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (void)confirmAction
{
    CPFindPileCity *city = self.cityArray[[self.pilePickerView selectedRowInComponent:0]][[self.pilePickerView selectedRowInComponent:1]];
    privateBlock(city);
    [self tappedCancel];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.provinceArray.count;
    }
    else if (component == 1)
    {
        NSInteger index = [pickerView selectedRowInComponent:0];
        if(self.cityArray.count >  index)
        {
            return [self.cityArray[index] count];
        }
        else
        {
            return 0;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width/2.0, kPickerRowH)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.numberOfLines = 0;
    myView.backgroundColor = [UIColor clearColor];
    myView.font = [UIFont boldSystemFontOfSize:18]; //用label来设置字体大小
    myView.textColor = [UIColor blackColor];
    if(component == 0)
    {
        if(self.provinceArray.count >  row)
        {
            myView.text = self.provinceArray[row];
        }
    }
    else if(component == 1)
    {
        NSInteger index = [pickerView selectedRowInComponent:0];
        if(self.cityArray.count >  index)
        {
            if([self.cityArray[index] count] > row)
            {
                CPFindPileCity *city = self.cityArray[index][row];
                myView.text = city.cityname;
            }
        }
    }
    return myView;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kPickerRowH;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        [pickerView reloadComponent:1];
    }
}
- (void)showPickerViewWithCity:(CPFindPileCity *)cityModel andBlock:(CMPCityPickerViewBlock)block
{
    privateBlock = block;
    [[[[UIApplication sharedApplication] delegate] window]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
         [bgView setFrame:CGRectMake(0, kScreenH - kPickerH, kScreenW, kPickerH)];
         int row1 = 0,row2 = 0;
         if(cityModel != nil)
         {
             for(int i = 0 ;i < self.provinceArray.count;i++)
             {
                 if([cityModel.province isEqualToString:self.provinceArray[i]])
                 {
                     row1 = i;
                     break;
                 }
             }
             [self pickerView:self.pilePickerView didSelectRow:row1 inComponent:0];
             [self.pilePickerView selectRow:row1 inComponent:0 animated:YES];

             for(int i = 0;i <[self.cityArray[row1] count] ;i++)
             {
                 CPFindPileCity *cityMember = self.cityArray[row1][i];
                 if([cityModel.cityname isEqualToString:cityMember.cityname])
                 {
                     row2 = i;
                     break;
                 }
             }
             [self pickerView:self.pilePickerView didSelectRow:row2 inComponent:1];
             [self.pilePickerView selectRow:row2 inComponent:1 animated:YES];
         }
         else
         {
             [self.pilePickerView reloadAllComponents];
         }
     }completion:^(BOOL finished)
     {
         
     }];
}

- (void)getAllData
{
    [self.provinceArray removeAllObjects];
    [self.cityArray removeAllObjects];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"provincecode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:descriptor, nil];
    NSArray *allArray = [[CPFindPileDBTool getAllCachedData] sortedArrayUsingDescriptors:sortDescriptors];
    for(int i = 0;i < allArray.count;i++)
    {
        CPFindPileCity *city = allArray[i];
        if([city.province rangeOfString:@"香港"].location != NSNotFound||[city.province rangeOfString:@"澳门"].location != NSNotFound||[city.province rangeOfString:@"台湾"].location != NSNotFound)
        {
            continue;
        }
        if(![self.provinceArray containsObject:city.province])
        {
            [self.provinceArray addObject:city.province];
        }
    }
    for(int i = 0;i < self.provinceArray.count;i++)
    {
        NSString *preString = [NSString stringWithFormat:@"province == '%@'",self.provinceArray[i]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:preString];
        NSArray *arrayPre = [allArray filteredArrayUsingPredicate:predicate];
        [self.cityArray addObject:arrayPre];
    }
}
@end
