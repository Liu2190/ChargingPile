//
//  CPAccountViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPAccountViewController.h"
#import "CPMyQRCodeViewController.h"
#import "CPEditInfoViewController.h"
#import "CPEditPasswordViewController.h"
#import "ZYQAssetPickerController.h"
#import "CPLoginViewController.h"

#import "CPLoginServer.h"
#import "BeRegularExpressionUtil.h"
#import "CMPAccount.h"
#import "NSDictionary+Additions.h"
#import "CPMyAccountView.h"
#import "UIActionSheet+Block.h"
#import "UIImage+CPAdditions.h"
#import "CPAccountUtility.h"
#import "ServerAPI.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

#define kTitle   @"cellTitle"
#define kImage @"cellImage"

@interface CPAccountViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CPMyAccountView *headerView;
    NSData *headerTempData;
    UIImage *selectImage;
}
@property (nonatomic,strong)UIButton *skipButton;
@end

@implementation CPAccountViewController
- (id)init
{
    if(self = [super init])
    {
        _isRegister = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    [self.dataArray addObject:@[@{kTitle:@"姓名",kImage:@"用户名"},@{kTitle:@"性别",kImage:@"性别"},@{kTitle:@"身份证号码",kImage:@"矢量智能对象"},@{kTitle:@"QQ",kImage:@"帮助与反馈"},@{kTitle:@"地址",kImage:@"电桩列表"}]];
    [self.dataArray addObject:@[@{kTitle:@"注册手机号码",kImage:@"登录手机号码"},@{kTitle:@"登录密码",kImage:@"登录密码"}]];
    [self.dataArray addObject:@[@{kTitle:@"关注二维码",kImage:@"矢3量智能对象"}]];
    headerView = [[CPMyAccountView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kCPMyAccountViewHeight)];
    headerView.accountNameLabel.text = [CMPAccount sharedInstance].accountInfo.name;
    headerView.sourceType = CPMyAccountViewTypeDetail;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookupAccount)];
    [headerView.accountImageView addGestureRecognizer:tap];
    self.tableView.tableHeaderView = headerView;
    [self readStoredImageData];
    [self setFooterView];
    [self getInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readStoredImageData) name:kNotificationUploadHeaderSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView) name:kNotificationUpdateUserInfoSuccess object:nil];
    // Do any additional setup after loading the view.
    if(_isRegister)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(kScreenWidth - 80, 20, 60, 30);
        _skipButton.backgroundColor = [UIColor whiteColor];
        _skipButton.alpha = 0.6;
        _skipButton.layer.cornerRadius = 4.0f;
        [_skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_skipButton setTitle:@"跳过>" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:_skipButton];
    }
}
- (void)leftMenuClick{
    if(self.isRegister)
    {
        [_skipButton removeFromSuperview];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)skipAction
{
    [_skipButton removeFromSuperview];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *imageName = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kImage];
    NSString *title = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kTitle];
    cell.textLabel.text = title;
    cell.textLabel.font = kOrderListCellFont;
    cell.detailTextLabel.font = kOrderListCellFont;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    cell.detailTextLabel.text = @"";
    if([cell.textLabel.text isEqualToString:@"姓名"])
    {
        cell.detailTextLabel.text = [CMPAccount sharedInstance].accountInfo.name;
    }
    else if([cell.textLabel.text isEqualToString:@"性别"])
    {
        cell.detailTextLabel.text = [[CMPAccount sharedInstance].accountInfo.gender isEqualToString:@"m"]?@"男":@"女";
    }
    else if([cell.textLabel.text isEqualToString:@"QQ"])
    {
        cell.detailTextLabel.text = [CMPAccount sharedInstance].accountInfo.qq;
    }
    else if([cell.textLabel.text isEqualToString:@"地址"])
    {
        cell.detailTextLabel.text = [CMPAccount sharedInstance].accountInfo.address;
    }
    else if([cell.textLabel.text isEqualToString:@"注册手机号码"])
    {
        cell.detailTextLabel.text = [CMPAccount sharedInstance].accountInfo.loginTelephone;
    }
    else if([cell.textLabel.text isEqualToString:@"身份证号码"])
    {
        cell.detailTextLabel.text = [CMPAccount sharedInstance].accountInfo.idNo;
    }
    else if([cell.textLabel.text isEqualToString:@"登录密码"])
    {
        cell.detailTextLabel.text = @"修改";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSString *title = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kTitle];
    if([title isEqualToString:@"姓名"])
    {
        CPEditInfoViewController *eVC = [[CPEditInfoViewController alloc]init];
        eVC.sourceType = EditInfoVCSourceTypeName;
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if ([title isEqualToString:@"性别"])
    {
        CPEditInfoViewController *eVC = [[CPEditInfoViewController alloc]init];
        eVC.sourceType = EditInfoVCSourceTypeGender;
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if ([title isEqualToString:@"QQ"])
    {
        CPEditInfoViewController *eVC = [[CPEditInfoViewController alloc]init];
        eVC.sourceType = EditInfoVCSourceTypeQQ;
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if ([title isEqualToString:@"地址"])
    {
        CPEditInfoViewController *eVC = [[CPEditInfoViewController alloc]init];
        eVC.sourceType = EditInfoVCSourceTypeAddress;
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if ([title isEqualToString:@"身份证号码"])
    {
        CPEditInfoViewController *eVC = [[CPEditInfoViewController alloc]init];
        eVC.sourceType = EditInfoVCSourceTypeIdCard;
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if ([title isEqualToString:@"注册手机号码"])
    {
        
    }
    else if ([title isEqualToString:@"登录密码"])
    {
        CPEditPasswordViewController *passVC = [[CPEditPasswordViewController alloc]init];
        [self.navigationController pushViewController:passVC animated:YES];
    }
    else if ([title isEqualToString:@"关注二维码"])
    {
        CPMyQRCodeViewController *qrVC = [[CPMyQRCodeViewController alloc]init];
        [self.navigationController pushViewController:qrVC animated:YES];
    }
}
#pragma mark - 退出登录
- (void)logOffAction
{
    [CMPAccount sharedInstance].accountInfo.isLogin = NO;
    if(self.isRegister)
    {
        UIViewController *viewController = [self getNavigationHistoryVC:[CPLoginViewController class]];
        [self.navigationController popToViewController:viewController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLogOffSuccess object:nil];
    }
}
- (void)setFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(80, 10, kScreenW - 160, 45);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(logOffAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure globalGreenColor]];
    [inquireButton setTitle:@"退出登录" forState:UIControlStateNormal];
    inquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}
- (void)getInfo
{
    [[ServerFactory getServerInstance:@"CPLoginServer"]doGetUserInfoWithSuccess:^(NSDictionary *callback)
     {
         NSLog(@"获取用户信息 = %@",callback);
         [[CMPAccount sharedInstance].accountInfo setDataWithDic:callback];
         [self.tableView reloadData];
     }andFailure:^(NSString *error)
     {
         NSLog(@"获取用户信息失败 = %@",error);
     }];
}
#pragma mark - 读取存储的头像
- (void)readStoredImageData
{
    UIImage *placeHolderImage;
    if(selectImage == nil)
    {
        placeHolderImage = [UIImage imageNamed:@"woItem"];
    }
    else{
        placeHolderImage = selectImage;
    }
    
    [headerView.accountImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/user/icon/%@",kServerHost,[CMPAccount sharedInstance].accountInfo.uid]] placeholderImage:placeHolderImage];
}
#pragma mark - 修改头像
- (void)lookupAccount
{
    //选择照片
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机拍照",@"从手机相册中选择", nil];
    [sheet showActionSheetWithClickBlock:^(NSInteger index)
     {
         if(index == 0)
         {
#if TARGET_IPHONE_SIMULATOR//模拟器
             
#elif TARGET_OS_IPHONE//真机
             UIImagePickerController *photosAlbumPC = [[UIImagePickerController alloc] init];
             photosAlbumPC.sourceType = UIImagePickerControllerSourceTypeCamera;
             photosAlbumPC.delegate = self;
             [self presentViewController:photosAlbumPC animated:YES completion:nil];
#endif
         }
         else if (index == 1)
         {
             [self openAllPhotos];
         }
     }];
}
- (void)openAllPhotos
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.assetsFilter = ZYQAssetsFilterAllPhotos;
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
            NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageWriteToSavedPhotosAlbum(orgImage,self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    [self uploadWith:orgImage];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i=0; i<assets.count; i++)
    {
        ZYQAsset *asset=assets[i];
        [asset setGetFullScreenImage:^(UIImage *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadWith:result];
            });
        }];
    }
}
#pragma mark - 上传图片
- (void)uploadWith:(UIImage *)image
{
    UIImage *scaleImage = [image scaleImageToScale:0.5];
    selectImage = scaleImage;
    NSData *imageData = UIImagePNGRepresentation(scaleImage);
    [MBProgressHUD showMessage:@""];
    [[CPAccountUtility getSharedInstance]startUploadUserHeaderIconWith:imageData withSuccessCallback:^(NSString *successCallback)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showSuccess:successCallback];
     }andFailureCallback:^(NSString *failureCallback)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:failureCallback];
     }];
}
#pragma mark - 数据修改成功
- (void)reloadView
{
    [self.tableView reloadData];
    headerView.accountNameLabel.text = [CMPAccount sharedInstance].accountInfo.name;
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
