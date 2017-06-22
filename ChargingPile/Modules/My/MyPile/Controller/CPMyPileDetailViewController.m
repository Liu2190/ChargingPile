//
//  CPMyPileDetailViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/8.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyPileDetailViewController.h"
#import "ZYQAssetPickerController.h"
#import "CPMyPileDateViewController.h"

#import "CPMyPileDetailTableViewCell.h"
#import "CPMyPilePictureTableViewCell.h"

#import "UIActionSheet+Block.h"
#import "ColorConfigure.h"
#import "UIImage+CPAdditions.h"
#import "MWPhotoBrowser.h"
#import "BeRegularExpressionUtil.h"
#import "ServerAPI.h"
#import "UIActionSheet+Block.h"
#import "CMPAccount.h"
#import "CPPileStationListModel.h"
#import "CPMyPileDateCreateDatePickerView.h"
#import "BeRegularExpressionUtil.h"

#define kTextFieldTag 999
@interface CPMyPileDetailViewController ()<CPMyPilePictureCellDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)CPMyPileDetailModel *detailModel;
@property (nonatomic,strong)NSMutableArray *stationArray;
@property (nonatomic,strong)CPPileStationListModel *selectStation;
@end

@implementation CPMyPileDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.detailModel = [[CPMyPileDetailModel alloc]init];
        self.imageArray = [[NSMutableArray alloc]init];
        self.stationArray = [[NSMutableArray alloc]init];
        self.selectStation = [[CPPileStationListModel alloc]init];
        self.selectStation.address = @"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电桩信息";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.dataArray addObject:@[@"电桩编号",@"时间段",@"电桩服务费(尖)",@"电桩服务费(峰)",@"电桩服务费(平)",@"电桩服务费(谷)",@"电桩类型"]];
    [self.dataArray addObject:@[@"额定功率",@"额定电压",@"额定电流"]];
    [self.dataArray addObject:@[/*@"站点",*/@"位置"]];
    [self.dataArray addObject:@[@"桩主姓名",@"桩主电话",@"电桩图片"]];
    if(self.sourceType == CPMyPileDetailVCSourceTypeEdit)
    {
        [self getDetailData];
    }
    if(self.sourceType == CPMyPileDetailVCSourceTypeCreate)
    {
        self.detailModel.userName = [CMPAccount sharedInstance].accountInfo.name;
    }
   // [self getStationList];
}
#pragma mark - 获取详情
- (void)getDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/pile/api/%@",kServerHost,self.pileId];
    [MBProgressHUD showMessage:@""];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         [MBProgressHUD hideHUD];
         NSLog(@"详情 = %@",responseObj);
         if(responseObj != nil)
         {
             [self.detailModel setDataWith:responseObj];
             self.selectStation.name = [self.detailModel.stationName mutableCopy];
             self.selectStation.stationId = [self.detailModel.stationId mutableCopy];
             self.selectStation.address = [self.detailModel.address mutableCopy];
         }
         for(NSString *member in self.detailModel.photos)
         {
             MWPhoto *photo;
             photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rest/pile/api/photo/%@",kServerHost,member]]];
             [self.imageArray addObject:photo];
         }
         [self.tableView reloadData];
         if(self.sourceType == CPMyPileDetailVCSourceTypeEdit && self.detailModel.status.intValue == 2)
         {
             [self displayRejectReason];
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}
#pragma mark - 查询电站列表
- (void)getStationList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/station/api/alls",kServerHost];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"电站列表信息 = %@",responseObj);
         for(NSDictionary *member in responseObj)
         {
             CPPileStationListModel *listModel = [[CPPileStationListModel alloc]initWithDict:member];
             if(self.selectStation.stationId.length > 0 && [listModel.stationId isEqualToString:self.selectStation.stationId])
             {
                 self.selectStation = listModel;
             }
             [self.stationArray addObject:listModel];
         }
         [self.tableView reloadData];
         
     }failure:^(NSError *error)
     {
         NSLog(@"电站列表失败 = %@",error);
     }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0.01:10.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2 && indexPath.section == 3)
    {
        return [CPMyPilePictureTableViewCell cellHight];
    }
    return [CPMyPileDetailTableViewCell cellHeightWith:@"llslsls" withArrowHidden:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.no andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag;
        cell.infoTextField.delegate = self;
        cell.infoTextField.keyboardType = UIKeyboardTypeASCIICapable;
        if(self.sourceType == CPMyPileDetailVCSourceTypeEdit && self.detailModel.status.intValue == 0)
        {
            cell.infoTextField.enabled = NO;
        }
        else
        {
            cell.infoTextField.enabled = YES;
        }
        return cell;
    }
    if(indexPath.row == 1 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.displayTime andPlaceHolder:@"" andArrowIsHidden:NO];
        cell.infoTextField.textColor = [ColorConfigure globalGreenColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.infoTextField.enabled = NO;
        cell.infoTextField.delegate = self;
        return cell;
    }
    if(indexPath.row == 2 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.feeJ andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 1;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"/kWh";
        cell.moneyIconLabel.hidden = NO;
        [cell setMoneyIconLabelFrame];
        return cell;
    }
    if(indexPath.row == 3 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.feeF andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 2;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"/kWh";
        cell.moneyIconLabel.hidden = NO;
        [cell setMoneyIconLabelFrame];
        return cell;
    }
    if(indexPath.row == 4 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.feeP andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 3;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"/kWh";
        cell.moneyIconLabel.hidden = NO;
        [cell setMoneyIconLabelFrame];
        return cell;
    }
    if(indexPath.row == 5 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.feeG andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 4;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"/kWh";
        cell.moneyIconLabel.hidden = NO;
        [cell setMoneyIconLabelFrame];
        return cell;
    }
    if(indexPath.row == 6 && indexPath.section == 0)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        NSString *typeString = [self.detailModel.types intValue] == 0?@"直流":@"交流";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.infoTextField.enabled = NO;
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:typeString andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 5;
        cell.infoTextField.delegate = self;
        return cell;
    }
    if(indexPath.row == 0 && indexPath.section == 1)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.power andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 6;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"kW";
        return cell;
    }
    if(indexPath.row == 1 && indexPath.section == 1)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.voltage andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 7;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"V";
        return cell;
    }
    if(indexPath.row == 2 && indexPath.section == 1)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.electricity andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 8;
        cell.infoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.infoTextField.delegate = self;
        cell.unitString = @"A";

        return cell;
    }
    /*if(indexPath.row == 0 && indexPath.section == 2)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.selectStation.name andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 9;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.infoTextField.enabled = NO;
        cell.infoTextField.delegate = self;
        return cell;
    }*/
    if(indexPath.row == 0 && indexPath.section == 2)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.selectStation.address andPlaceHolder:@"请填写详细"andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 10;
        cell.infoTextField.delegate = self;
        return cell;
    }
    if(indexPath.row == 0 && indexPath.section == 3)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row] andTextFiled:self.detailModel.userName andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 11;
        cell.infoTextField.delegate = self;
        return cell;
    }
    if(indexPath.row == 1 && indexPath.section == 3)
    {
        CPMyPileDetailTableViewCell *cell = [CPMyPileDetailTableViewCell cellWithTableView:tableView];
        [cell setCellWithName:self.dataArray[indexPath.section] [indexPath.row]  andTextFiled:self.detailModel.phone andPlaceHolder:@"" andArrowIsHidden:YES];
        cell.infoTextField.tag = kTextFieldTag + 12;
        cell.infoTextField.keyboardType = UIKeyboardTypePhonePad;
        cell.infoTextField.delegate = self;
        return cell;
    }
    if(indexPath.row == 2 && indexPath.section == 3)
    {
        CPMyPilePictureTableViewCell *cell = [CPMyPilePictureTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        [cell setupSubviewsWithArray:self.imageArray];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1 && indexPath.section == 0)
    {
        CPMyPileDateViewController *dateVC = [[CPMyPileDateViewController alloc]init];
        CPPileDateModel *dateModel = [[CPPileDateModel alloc]init];
        dateModel.days = [self.detailModel.serveDays mutableCopy];
        dateModel.beginTime = [self.detailModel.serveTimeBegin mutableCopy];
        dateModel.endTime = [self.detailModel.serveTimeEnd mutableCopy];
        dateVC.selectModel = dateModel;
        dateVC.block =^(CPPileDateModel *dateModel)
        {
            self.detailModel.serveDays = [dateModel.days mutableCopy];
            self.detailModel.serveTimeBegin = [dateModel.beginTime mutableCopy];
            self.detailModel.serveTimeEnd = [dateModel.endTime mutableCopy];
            [self.detailModel setDisplayTimeData];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:dateVC animated:YES];
    }
    if(indexPath.row == 6 && indexPath.section == 0)
    {
        //电桩类型
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"直流",@"交流", nil];
        [sheet showActionSheetWithClickBlock:^(NSInteger index)
         {
             self.detailModel.types = [NSString stringWithFormat:@"%d",(int)index];
             [self.tableView reloadData];
         }];
    }
   /*if(indexPath.row == 0 && indexPath.section == 2)
    {
        [[CPMyPileDateCreateDatePickerView sharedInstance]showPickerViewArray:self.stationArray andSelectIndex:0 andBlock:^(NSInteger index)
        {
            self.selectStation = [self.stationArray objectAtIndex:index];
            [self.tableView reloadData];
        }];
    }*/
}
#pragma mark - 修改、上传
- (void)rightAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.sourceType == CPMyPileDetailVCSourceTypeEdit)
    {
        params[@"id"] = self.detailModel.pileId;//	电桩id
    }
    if(self.detailModel.no.length < 1)
    {
        [MBProgressHUD showError:@"请填写电桩编号"];
        return;
    }
    params[@"no"]= self.detailModel.no;//	电桩名称
    
    if(self.detailModel.serveDays.length < 1 || self.detailModel.serveTimeBegin.length < 1 || self.detailModel.serveTimeEnd.length < 1)
    {
        [MBProgressHUD showError:@"请补全服务时间"];
        return;
    }
    params[@"serveDays"]= self.detailModel.serveDays;//	服务时间周几
    params[@"serveTimeBegin"]= self.detailModel.serveTimeBegin;//	服务时间开始
    params[@"serveTimeEnd"]= self.detailModel.serveTimeEnd;//	服务时间截止
    
    if(self.detailModel.feeJ.length < 1)
    {
        [MBProgressHUD showError:@"请填写尖服务费"];
        return;
    }
    params[@"feeJ"]= self.detailModel.feeJ;//	尖服务费
    if(self.detailModel.feeF.length < 1)
    {
        [MBProgressHUD showError:@"请填写峰服务费"];
        return;
    }
    params[@"feeF"]= self.detailModel.feeF;//	峰服务费
    if(self.detailModel.feeP.length < 1)
    {
        [MBProgressHUD showError:@"请填写平服务费"];
        return;
    }
    params[@"feeP"]= self.detailModel.feeP;//	平服务费
    if(self.detailModel.feeG.length < 1)
    {
        [MBProgressHUD showError:@"请填写谷服务费"];
        return;
    }
    params[@"feeG"]= self.detailModel.feeG;//	谷服务费
    
    if(self.detailModel.types.length < 1)
    {
        [MBProgressHUD showError:@"请选择电桩类型"];
        return;
    }
    params[@"types"]= self.detailModel.types;//	类型见“电桩类型”码表
    
    if(self.detailModel.power.length < 1)
    {
        [MBProgressHUD showError:@"请填写额定功率"];
        return;
    }
    params[@"power"]= self.detailModel.power;//	额定功率
    if(self.detailModel.voltage.length < 1)
    {
        [MBProgressHUD showError:@"请填写额定电压"];
        return;
    }
    params[@"voltage"]= self.detailModel.voltage;//	额定电压
    if(self.detailModel.electricity.length < 1)
    {
        [MBProgressHUD showError:@"请填写额定电流"];
        return;
    }
    params[@"electricity"]= self.detailModel.electricity;//	额定电流
    if(self.selectStation.address.length < 1)
    {
        [MBProgressHUD showError:@"请填写电站地址"];
        return;
    }
    params[@"address"]= self.selectStation.address;//	地址
   // params[@"stationId"]= self.selectStation.stationId;//	电站ID
    params[@"userId"]= [CMPAccount sharedInstance].accountInfo.uid;//	用户ID
    if(self.detailModel.phone.length < 1)
    {
        [MBProgressHUD showError:@"请填写电话"];
        return;
    }
    params[@"phone"]= self.detailModel.phone;//	电话
    
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/pile/api/add",kServerHost];
    
    [MBProgressHUD showMessage:@""];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if(params!=nil)
         {
             for (NSString *key in params) {
                 id value = [params objectForKey:key];
                 [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
             }
         }
        for(MWPhoto *photo in self.imageArray)
        {
            if(photo.image != nil)
            {
                NSData *imageData = UIImagePNGRepresentation(photo.image);
                [formData appendPartWithFileData:imageData name:@"photo" fileName:@"file.png" mimeType:@"image/png"];
            }
         }
     } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUD];
         NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"上传 = %@",responseDict);
         if([[responseDict objectForKey:@"state"] intValue ] == 0)
         {
             NSString *success = self.sourceType == CPMyPileDetailVCSourceTypeCreate?@"上传电桩成功":@"修改电桩成功";
             [MBProgressHUD showSuccess:success];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 if(self.block)
                 {
                     self.block();
                 }
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }
         else{
             if(self.sourceType == CPMyPileDetailVCSourceTypeCreate)
             {
                 UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"该电桩编号已注册，请联系客户人员" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [al show];
                 return;
             }
             else
             {
                 [MBProgressHUD showError:@"修改电桩失败"];

             }
        }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUD];
         NSLog(@"上传失败 = %@",error);
         NSString *errorMsg = self.sourceType == CPMyPileDetailVCSourceTypeCreate?@"上传电桩失败":@"修改电桩失败";
         [MBProgressHUD showError:errorMsg];
     }];
}
#pragma mark - textfieldDelegate
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = [noti object];
    int tag = (int)[tf tag];
    switch (tag) {
        case kTextFieldTag:
        {
            self.detailModel.no = tf.text;
        }
            break;
        case kTextFieldTag + 1:
        {
            self.detailModel.feeJ = tf.text;
            CPMyPileDetailTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [cell2 setMoneyIconLabelFrame];
        }
            break;
        case kTextFieldTag + 2:
        {
            self.detailModel.feeF = tf.text;
            CPMyPileDetailTableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell3 setMoneyIconLabelFrame];
        }
            break;
        case kTextFieldTag + 3:
        {
            self.detailModel.feeP = tf.text;
            CPMyPileDetailTableViewCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            [cell4 setMoneyIconLabelFrame];
        }
            break;
        case kTextFieldTag + 4:
        {
            self.detailModel.feeG = tf.text;
            CPMyPileDetailTableViewCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            [cell5 setMoneyIconLabelFrame];

        }
            break;
        case kTextFieldTag + 5:
        {

        }
            break;
        case kTextFieldTag + 6:
        {
            self.detailModel.power = tf.text;

        }
            break;
        case kTextFieldTag + 7:
        {
            self.detailModel.voltage = tf.text;

        }
            break;
        case kTextFieldTag + 8:
        {
            self.detailModel.electricity = tf.text;

        }
            break;
        case kTextFieldTag + 9:
        {
            self.selectStation.name = tf.text;

        }
            break;
        case kTextFieldTag + 10:
        {
            self.selectStation.address  = tf.text;

        }
            break;
        case kTextFieldTag + 11:
        {
            self.detailModel.userName = tf.text;

        }
            break;
        case kTextFieldTag + 12:
        {
            self.detailModel.phone = tf.text;
            if(tf.text.length == 11 && ![BeRegularExpressionUtil validateMobile:tf.text])
            {
                [MBProgressHUD showError:@"请输入正确格式的手机号码"];
            }
        }
            break;
            
        default:
            break;
    }
   /* CPMyPileDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.detailModel.pileId = cell.infoTextField.text;

    

    

    
    

    
    
    
    CPMyPileDetailTableViewCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    self.detailModel.power = cell6.infoTextField.text;

    
    CPMyPileDetailTableViewCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    self.detailModel.voltage = cell7.infoTextField.text;

    CPMyPileDetailTableViewCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    self.detailModel.electricity = cell8.infoTextField.text;
    
    CPMyPileDetailTableViewCell *cell10 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    self.detailModel.userName = cell10.infoTextField.text;
    
    CPMyPileDetailTableViewCell *cell9 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
    self.detailModel.phone = cell9.infoTextField.text;
    
    CPMyPileDetailTableViewCell *cell12 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    self.selectStation.address = cell12.infoTextField.text;//	地址
    */
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int tag = (int)textField.tag;
    if(textField.tag == kTextFieldTag)
    {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger length = textField.text.length + string.length - range.length;
        return length <= 16;
    }
    if(textField.tag == kTextFieldTag + 12)
    {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger length = textField.text.length + string.length - range.length;
        return length <= 11;
    }
    if(!(tag == kTextFieldTag + 1 ||tag == kTextFieldTag + 2 ||tag == kTextFieldTag + 3 ||tag == kTextFieldTag + 4||tag == kTextFieldTag + 6 ||tag == kTextFieldTag + 7 ||tag == kTextFieldTag + 8 ) )
    {
        return YES;
    }
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound)
    {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt= (int)range.location-(int)ran.location;
                    if (tt <= 2){
                        return YES;
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }
        else
        {//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
#pragma mark - 选择照片
- (void)selectImageWith:(NSInteger)index
{
    if(index < self.imageArray.count)
    {
        //浏览照片
        [self browserWithIndex:(int)index];
    }
    else
    {
        //选择照片
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
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
                 ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                 picker.maximumNumberOfSelection = kImageMaxCount - self.imageArray.count;
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
         }];
    }
}
#pragma mark - 浏览图片
- (void)browserWithIndex:(int)index
{
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL showRightBarButton = YES;
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
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    //删除照片
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showActionSheetWithClickBlock:^(NSInteger index)
     {
         [self deleteImageWithIndex:(int)photoBrowser.currentIndex];
         [self.imageArray removeObjectAtIndex:photoBrowser.currentIndex];
         [photoBrowser reloadData];
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
     }];
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageWriteToSavedPhotosAlbum(orgImage,self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    MWPhoto *photo;
    photo = [MWPhoto photoWithImage:orgImage];
    [self.imageArray addObject:photo];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
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
                MWPhoto *photo;
                photo = [MWPhoto photoWithImage:result];
                [self.imageArray addObject:photo];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
    }
}
#pragma mark - 在网上删除图片
- (void)deleteImageWithIndex:(int )index
{
    NSLog(@"删除的index = %d",index);
    MWPhoto *photo = self.imageArray[index];
    if(photo.photoURL != nil)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@",photo.photoURL];
        NSString *photoId = [[urlString componentsSeparatedByString:@"/"] lastObject];
        NSString *urlStr = [NSString stringWithFormat:@"%@rest/pile/api/delImg/%@",kServerHost,photoId];
        [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
         {
             NSLog(@"删除= %@",responseObj);
             if([[responseObj objectForKey:@"state"] intValue] == 0)
             {
                 
             }
         }failure:^(NSError *error)
         {
             
         }];
    }
}
#pragma mark - 显示审核未通过的原因
- (void)displayRejectReason
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0, headerView.width - 30, 20)];
    titleLabel.text = [NSString stringWithFormat:@"审核失败的原因：%@",self.detailModel.rejectReason];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor darkGrayColor];
    [headerView addSubview:titleLabel];
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = titleLabel.font;
    CGRect nameRect = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    headerView.height = nameRect.size.height + 30;
    titleLabel.height = nameRect.size.height;
    titleLabel.centerY = headerView.height/2.0;
    self.tableView.tableHeaderView = headerView;
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
