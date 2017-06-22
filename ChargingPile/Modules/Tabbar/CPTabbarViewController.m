//
//  CPTabbarViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPTabbarViewController.h"
#import "CPChargeViewController.h"
#import "CPDynamicViewController.h"
#import "CPFindPileViewController.h"
#import "CPMyViewController.h"
#import "CPLoginViewController.h"
#import "CPNavigationController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "CPChargeProceduceViewController.h"

#import "AppDelegate.h"

#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "CMPAccount.h"
#import "CPLoginServer.h"
#import "CPFindPileDBTool.h"
#import "CPFindPileServer.h"
#import "CPChargeServer.h"
#import "ServerFactory.h"

@interface CPTabbarViewController ()<UITextFieldDelegate>
{
    UIBarButtonItem *leftItem;
    UIBarButtonItem *rightItem1;
    UIBarButtonItem *rightItem2;
    UIBarButtonItem *rightItem3;
    UIBarButtonItem *cancelItem;

    UIView *view;
    
    UIView *searchView;
    UIView *searchTitleView;
    UITextField *searchTf;
    UILabel *leftBarButtonItemLabel;
    
    CPChargeViewController *chargeVC;
    CPFindPileViewController *findVC;
    CPDynamicViewController *dynamicVC;
    CPMyViewController *myVC;
    BOOL isShowMap;
}

@end

@implementation CPTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShowMap = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveRightItemChange:) name:kNotificationRightButtonItem object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveLeftItemChange:) name:kNotificationLeftButtonItem object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveSearchKeyWord:) name:kNotificationSearchKeywords object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkLoginStatusAction) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllCity) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [self setSubviews];
}

- (void)setSubviews
{
    view = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50, 0, 100, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePageTitle"]];
    titleView.centerX = view.width/2.0;
    titleView.centerY = view.height/2.0;
    [view addSubview:titleView];
    self.navigationItem.titleView = view;
    
    chargeVC = [[CPChargeViewController alloc]init];
    findVC = [[CPFindPileViewController alloc]init];
    dynamicVC = [[CPDynamicViewController alloc]init];
    myVC = [[CPMyViewController alloc]init];
    chargeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"充电" image:[[UIImage imageNamed:@"chongdianItem"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"chongdian2Item"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    chargeVC.tabBarItem.tag = 0;
    
    findVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"找电桩" image:[[UIImage imageNamed:@"dianzhuangItem"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"dianzhuang2Item"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    findVC.tabBarItem.tag = 1;
    
    dynamicVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:[[UIImage imageNamed:@"dongtaidongtaiItem"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"dongtaidongtai2Item"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    dynamicVC.tabBarItem.tag = 2;
    
    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"woItem"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"wo2Item"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    myVC.tabBarItem.tag = 3;
    
    self.viewControllers = @[chargeVC,findVC,dynamicVC,myVC];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[ColorConfigure globalGreenColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    rightItem1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"导航-拷贝"] style:UIBarButtonItemStylePlain target:findVC action:@selector(rightAction)];
    
    rightItem3 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"列表"] style:UIBarButtonItemStylePlain target:findVC action:@selector(rightAction)];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setTitle:@"客服" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:myVC action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSearch)];
    
    
    searchTitleView = [[UIView alloc]initWithFrame:CGRectMake(90, 0, kScreenW - 90 - 70, 31)];
    searchTitleView.backgroundColor = [UIColor whiteColor];
    searchTitleView.layer.cornerRadius = 4.0f;
    UIImage *rightImage = [UIImage imageNamed:@"搜索"];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
    rightImageView.centerY = searchTitleView.height/2.0;
    rightImageView.x = searchTitleView.width - 20;
    [searchTitleView addSubview:rightImageView];
    searchTitleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startSearch)];
    [searchTitleView addGestureRecognizer:tap1];
    
    searchTf = [[UITextField alloc]initWithFrame:CGRectMake(3, 0, searchTitleView.width - 3 - rightImage.size.width - 3, searchTitleView.height)];
    searchTf.tintColor= [UIColor lightGrayColor];
    searchTf.enabled = NO;
    [searchTitleView addSubview:searchTf];
    
    
    leftBarButtonItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    leftBarButtonItemLabel.font = [UIFont systemFontOfSize:14];
    leftBarButtonItemLabel.numberOfLines = 0;
    leftBarButtonItemLabel.text = @"定位失败";
    leftBarButtonItemLabel.textColor = [UIColor whiteColor];
    leftBarButtonItemLabel.userInteractionEnabled = YES;
    leftBarButtonItemLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:findVC action:@selector(leftAction)];
    [leftBarButtonItemLabel addGestureRecognizer:leftTap];
    leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButtonItemLabel];
    [self tabBar:self.tabBar didSelectItem:findVC.tabBarItem];
    self.selectedIndex = 1;
}
- (void)setupSearchTf
{
    searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 10 - 70, 31)];
    searchView.layer.cornerRadius = 5.0f;
    searchView.backgroundColor = [UIColor whiteColor];
    UIImage *searchImage = [UIImage imageNamed:@"搜索"];
    UIView *rigtSearchView = [[UIView alloc] initWithFrame:CGRectMake(searchView.width - searchImage.size.width - 3, 0, searchImage.size.width + 3, searchImage.size.height)];
    rigtSearchView.backgroundColor = [UIColor clearColor];
    rigtSearchView.centerY = searchView.height/2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:searchImage];
    [rigtSearchView addSubview:imageView];
    [searchView addSubview:rigtSearchView];
    
    searchTf = [[UITextField alloc]initWithFrame:CGRectMake(3, 0, searchView.width - 3 - searchImage.size.width - 3, searchView.height)];
    searchTf.tintColor= [UIColor lightGrayColor];
    searchTf.delegate = findVC;
    searchTf.returnKeyType = UIReturnKeySearch;
    searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchView addSubview:searchTf];
    [searchTf addDoneOnKeyboardWithTarget:findVC action:@selector(textFiledDoneAction)];
    for(UIView *subview in [searchView subviews])
    {
        subview.userInteractionEnabled = YES;
    }
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.navigationItem.titleView = view;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }else if (item.tag == 1){
        self.navigationItem.titleView = searchTitleView;
        self.navigationItem.rightBarButtonItem = rightItem1;
        self.navigationItem.leftBarButtonItem = leftItem;
    }else if (item.tag == 2){
        self.title = @"动态关注";
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else if(item.tag == 3)
    {
        self.title =@"我";
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = rightItem2;
        self.navigationItem.leftBarButtonItem = nil;
    }
}
#pragma mark - 查看是否登录
- (void)checkLoginStatusAction
{
    if([CMPAccount sharedInstance].accountInfo.isLogin)
    {
        [[CMPAccount sharedInstance].accountInfo clearData];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLoginSuccess object:nil];
        [[ServerFactory getServerInstance:@"CPLoginServer"]doGetUserInfoWithSuccess:^(NSDictionary *callback)
         {
             NSLog(@"获取用户信息 = %@",callback);
             [[CMPAccount sharedInstance].accountInfo setDataWithDic:callback];
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUpdateUserInfoSuccess object:nil];
         }andFailure:^(NSString *error)
         {
             NSLog(@"获取用户信息失败 = %@",error);
         }];
        
        NSString *orderId = [[NSUserDefaults standardUserDefaults]objectForKey:kLatestChargeOrderId];
        if(orderId != nil && orderId.length > 0)
        {
            [[ServerFactory getServerInstance:@"CPChargeServer"]doGetChargeInfoWithOrderId:orderId andSuccessCallback:^(NSDictionary *callback)
             {
                 NSString *status = [callback stringValueForKey:@"status"];
                 if([status intValue] == 1)
                 {
                     CPChargeProceduceViewController *toCharge = [[CPChargeProceduceViewController alloc]init];
                     toCharge.orderId = orderId;
                     UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
                     [topViewController.navigationController pushViewController:toCharge animated:YES];
                 }
             }andFailureCallback:^(NSString *error)
             {
                 NSLog(@"查询订单失败 = %@",error);
             }];
        }
    }
    else
    {
        UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
        CPLoginViewController *loginVC = [[CPLoginViewController alloc]init];
        CPNavigationController *nav = [[CPNavigationController alloc]initWithRootViewController:loginVC];
        [topViewController.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - rightButtonItem改变
- (void)receiveRightItemChange:(NSNotification *)noti
{
    if([[noti.userInfo objectForKey:@"isMapHidden"] boolValue] == YES)
    {
        isShowMap = NO;
        self.navigationItem.rightBarButtonItem = rightItem1;
    }
    else
    {
        isShowMap = YES;
        self.navigationItem.rightBarButtonItem = rightItem3;
    }
}
- (void)receiveLeftItemChange:(NSNotification *)noti
{
    leftItem = nil;
    NSString *cityName = [noti.userInfo objectForKey:kLeftItemCityName];
    leftBarButtonItemLabel.text = cityName;
    leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButtonItemLabel];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)receiveSearchKeyWord:(NSNotification *)noti
{
    searchTf.text = [noti.userInfo objectForKey:kNotificationSearchKeywords];
}
#pragma mark - 开始搜索
- (void)startSearch
{
   /* [self setupSearchTf];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = cancelItem;
    self.navigationItem.titleView = searchView;*/
    [findVC startSearchWith:searchTf];
   // [searchTf becomeFirstResponder];
}
#pragma mark - 结束搜索
- (void)cancelSearch
{
    searchView = nil;
    searchTf = nil;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.titleView = searchTitleView;
    if(isShowMap == NO)
    {
        self.navigationItem.rightBarButtonItem = rightItem1;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = rightItem3;
    }
    [findVC cancelAction];
}
- (void)getAllCity
{
    if([[CPFindPileDBTool getAllCachedData] count] == 0)
    {
        [[ServerFactory getServerInstance:@"CPFindPileServer"]getSupportCityWithSuccessCallback:^(NSDictionary *callback)
         {
             for(int i = 0;i < [callback allKeys].count;i++)
             {
                 NSString *key = [callback allKeys][i];
                 NSString *province = [[key componentsSeparatedByString:@"|"] lastObject];
                 NSString *provincecode = [[key componentsSeparatedByString:@"|"] firstObject];
                 NSArray *cityArray = [callback objectForKey:key];
                 for(int j = 0;j < cityArray.count;j++)
                 {
                     NSString *value = cityArray[j];
                     NSString *cityname = [[value componentsSeparatedByString:@"|"] lastObject];
                     NSString *citycode = [[value componentsSeparatedByString:@"|"] firstObject];
                     [CPFindPileDBTool saveDataWithProvince:province  andProvinceCode:provincecode andCityName:cityname andCityCode:citycode];
                 }
             }
         }andFailureCallback:^(NSError *error)
         {
             
         }];
    }
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
