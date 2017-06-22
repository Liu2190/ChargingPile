//
//  CPMyQRCodeViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/9.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPMyQRCodeViewController.h"
#import "CMPAccount.h"

@interface CPMyQRCodeViewController ()

@end

@implementation CPMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注二维码";
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setFooterView];
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:@""];
    //cell.textLabel.text = [CMPAccount sharedInstance].accountInfo.manager;
    cell.textLabel.textColor = [UIColor darkGrayColor];
   // cell.detailTextLabel.text = [CMPAccount sharedInstance].accountInfo.address;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}
- (void)setFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 110)];
    UIImageView *imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"二维码"]];
    imgview.centerX = kScreenW/2.0;
    imgview.y = 20.0f;
    [tableFooterView addSubview:imgview];
    
    UIImageView *qrImgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qrcode"]];
    qrImgview.centerX = imgview.width/2.0;
    qrImgview.y = (105.0/(95.0 + 154.0)) *imgview.height;
    [imgview addSubview:qrImgview];

    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 ,kScreenW,30)];
    contentLabel.centerX = tableFooterView.centerX;
    contentLabel.y = CGRectGetMaxY(imgview.frame);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.text = @"扫一扫上面的二维码图案，关注我们";
    [tableFooterView addSubview:contentLabel];
    self.tableView.tableFooterView = tableFooterView;
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
