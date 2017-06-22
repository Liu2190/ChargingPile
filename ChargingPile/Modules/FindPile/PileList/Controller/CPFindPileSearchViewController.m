//
//  CPFindPileSearchViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2017/1/10.
//  Copyright © 2017年 chargingPile. All rights reserved.
//

#import "CPFindPileSearchViewController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CPFindPileSearchHeaderView.h"
#import "CPSearchConditionView.h"
#import "CPFindPileServer.h"
#import "CPPileDetailViewController.h"
#import "CPPlieModel.h"

#define kNameConditionKey @"nameConditionKey"
@interface CPFindPileSearchViewController ()<UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate>
{
    UITextField *searchTf;
    CPFindPileSearchHeaderView *headerView;
    UIButton *conditionButton;
    BOOL isNameCondition;
}
@property (nonatomic,strong)AMapSearchAPI *mapSearcher;

@end

@implementation CPFindPileSearchViewController

- (void)setCityName:(NSString *)cityName
{
    _cityName = [cityName mutableCopy];
    if ([_cityName rangeOfString:@"市"].location != NSNotFound && [_cityName rangeOfString:@"州"].location != NSNotFound)
    {
        //过滤掉郑州市的“市”字
        _cityName = [[_cityName componentsSeparatedByString:@"市"] firstObject];
    }
    else if ([_cityName rangeOfString:@"州"].location != NSNotFound && [_cityName rangeOfString:@"市"].location == NSNotFound)
    {
        //过滤掉阿坝州的州字（郑州，广州不可过滤）
        _cityName = [[_cityName componentsSeparatedByString:@"州"] firstObject];
    }
    else if([_cityName rangeOfString:@"市"].location != NSNotFound)
    {
        //过滤掉市字
        _cityName = [[_cityName componentsSeparatedByString:@"市"] firstObject];
    }
    if ([_cityName rangeOfString:@"地区"].location != NSNotFound)
    {
        //过滤掉地区字
        _cityName = [[_cityName componentsSeparatedByString:@"地区"] firstObject];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [self getDataFromHistory];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [searchTf becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isNameCondition = NO;
    // Do any additional setup after loading the view.
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 70, 31)];
    searchView.layer.cornerRadius = 5.0f;
    searchView.backgroundColor = [UIColor whiteColor];
    searchTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, searchView.width , searchView.height)];
    searchTf.tintColor= [UIColor lightGrayColor];
    searchTf.delegate = self;
    searchTf.returnKeyType = UIReturnKeySearch;
    searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchView addSubview:searchTf];

    conditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    conditionButton.frame = CGRectMake(0, 0, 60, searchTf.height);
    conditionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [conditionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"pull_click"];
    [conditionButton setImage:image forState:UIControlStateNormal];
    [conditionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [conditionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
    [conditionButton addTarget:self action:@selector(conditionAction) forControlEvents:UIControlEventTouchUpInside];
    searchTf.leftView = conditionButton;
    searchTf.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = searchView;
    
    headerView = [[CPFindPileSearchHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kCPFindPileSearchHeaderViewHeight)];
    [headerView.clearButton addTarget:self action:@selector(clearAllData) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = headerView;
    self.mapSearcher = [[AMapSearchAPI alloc] init];
    self.mapSearcher.delegate = self;
}
- (void)getDataFromHistory
{
    [self.dataArray removeAllObjects];
    if(isNameCondition)
    {
        [conditionButton setTitle:kConditionName forState:UIControlStateNormal];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *tempArray = [user objectForKey:kNameConditionKey];
        for(NSDictionary *member in tempArray)
        {
            CPPlieModel *listModel = [[CPPlieModel alloc]initWithDict:member];
            [self.dataArray addObject:listModel];
        }
        [self.tableView reloadData];
    }
    else{
        [conditionButton setTitle:kConditionLocation forState:UIControlStateNormal];
        [self.dataArray addObjectsFromArray:[CPSearchHistory getAllCachedDataWithCityName:self.cityName]];
        [self.tableView reloadData];
    }
    
    if(self.dataArray.count > 0)
    {
        headerView.clearButton.enabled = YES;
        [headerView.clearButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    }
    else
    {
        headerView.clearButton.enabled = NO;
        [headerView.clearButton setTitle:@"没有搜索历史" forState:UIControlStateNormal];
    }
    headerView.titleLbael.text = @"搜索历史";
}
- (void)conditionAction
{
    [[CPSearchConditionView sharedInstance]showPickerViewWithBlock:^(BOOL isName)
     {
         if(isNameCondition == isName)
         {
             return;
         }
         isNameCondition = isName;
         [self getDataFromHistory];
     }];
}
- (void)clearAllData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@[] forKey:kNameConditionKey];
    [CPSearchHistory clearAllCachedData];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    headerView.clearButton.enabled = NO;
    [headerView.clearButton setTitle:@"没有搜索历史" forState:UIControlStateNormal];
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = noti.object;
    if(tf.text.length < 2)
    {
        return;
    }
    if(isNameCondition)
    {
        [self startNameSearch];
    }
    else
    {
        [self startLocationSearch];
    }
    headerView.clearButton.enabled = NO;
    [headerView.clearButton setTitle:@"" forState:UIControlStateNormal];
    headerView.titleLbael.text = @"搜索结果";
}
- (void)textFiledDoneAction
{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
}
- (void)startLocationSearch
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = searchTf.text;
    request.city                = self.cityName;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types               = @"商务住宅|道路附属设施|交通设施服务";
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.mapSearcher AMapPOIKeywordsSearch:request];
}
- (void)startNameSearch
{
    [[ServerFactory getServerInstance:@"CPFindPileServer"]doSearchPileWith:searchTf.text andSuccessCallback:^(id callback)
     {
         NSLog(@"搜索充电站 = %@",callback);
         [self.dataArray removeAllObjects];
         if([callback isKindOfClass:[NSArray class]])
         {
             for(NSDictionary *member in callback)
             {
                 CPPlieModel *listModel = [[CPPlieModel alloc]initWithDict:member];
                 [self.dataArray addObject:listModel];
             }
         }
         [self.tableView reloadData];
     }andFailureCallback:^(NSString *error)
     {
         NSLog(@"搜索失败 = %@",error);
     }];
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"response.pois=%@",response.pois);
    [self.dataArray removeAllObjects];
    for(AMapPOI *obj in response.pois)
    {
        CPPileLocationSearchModel *searchModel = [[CPPileLocationSearchModel alloc]init];
        searchModel.locationCity = self.cityName;
        searchModel.locationName = obj.name;
        searchModel.loactionAddress = obj.address;
        searchModel.locationLatitude = [NSString stringWithFormat:@"%f",obj.location.latitude];
        searchModel.locationLongitude = [NSString stringWithFormat:@"%f",obj.location.longitude];
        [self.dataArray addObject:searchModel];
    }
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    if(isNameCondition)
    {
        CPPlieModel *listModel = self.dataArray[indexPath.row];
        cell.textLabel.text = listModel.name;
        cell.detailTextLabel.text = listModel.address;
    }
    else
    {
        CPPileLocationSearchModel *searchModel = self.dataArray[indexPath.row];
        cell.textLabel.text = searchModel.locationName;
        cell.detailTextLabel.text = searchModel.loactionAddress;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(isNameCondition)
    {
        CPPlieModel *listModel = self.dataArray[indexPath.row];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *tempArray = [user objectForKey:kNameConditionKey];
        if(tempArray != nil && tempArray.count > 0)
        {
            BOOL isExist = NO;
            for(NSDictionary *member in tempArray)
            {
                if([[member stringValueForKey:@"name"] isEqualToString:listModel.name] &&[[member stringValueForKey:@"id"] isEqualToString:listModel.pileId])
                {
                    isExist = YES;
                }
            }
            if(!isExist)
            {
                NSMutableArray *allData = [NSMutableArray arrayWithObject:tempArray];
                [allData addObject:listModel.storedDict];
                [user setObject:[NSArray arrayWithArray:allData] forKey:kNameConditionKey];
            }
        }
        else
        {
            [user setObject:@[listModel.storedDict] forKey:kNameConditionKey];
        }
        CPPileDetailViewController *detailVC = [[CPPileDetailViewController alloc]init];
        detailVC.sourceType = CPPileDetailVCTypeFind;
        detailVC.pileModel = listModel;
        detailVC.currentLocation = self.currentLocation;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        CPPileLocationSearchModel *searchModel = self.dataArray[indexPath.row];
        [CPSearchHistory saveDataWithModel:searchModel];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSearchKeywords object:nil userInfo:@{kNotificationSearchKeywords:searchModel.locationName}];
        if(self.block)
        {
            self.block(searchModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
