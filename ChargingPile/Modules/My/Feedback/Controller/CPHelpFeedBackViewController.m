//
//  CPHelpFeedBackViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPHelpFeedBackViewController.h"
#import "ServerAPI.h"
#import "NSDictionary+Additions.h"
#import "ColorUtility.h"

@interface CPHelpFeedBackViewController ()
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *footerView;

@end

@implementation CPHelpFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与反馈";
    [self getDataFromServer];
    [self setFooterView];
    self.view.backgroundColor = [ColorUtility colorWithRed:237 green:238 blue:239];
    self.tableView.backgroundColor = self.view.backgroundColor;
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (void)setFooterView
{
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    self.footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 7, 200, 20)];
    titleLabel.text = @"常见问题";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor darkGrayColor];
    [self.footerView addSubview:titleLabel];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, kScreenW - 20, 0)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 8.0f;
    [self.footerView addSubview:self.bgView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.bgView.width - 20, 0)];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor darkGrayColor];
    [self.bgView addSubview:self.contentLabel];
}
- (void)getDataFromServer
{
    NSString *urlStr = [NSString stringWithFormat:@"%@rest/doc/api/0",kServerHost];
    [[CPHttp sharedInstance]getPath:urlStr withParameters:nil success:^(id responseObj)
     {
         NSLog(@"帮助与反馈的数据 = %@",responseObj);
         [self setViewWith:[responseObj stringValueForKey:@"content"]];
     }failure:^(NSError *error)
     {
     }];
}
- (void)setViewWith:(NSString *)content
{
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = self.contentLabel.font;
    CGRect nameRect = [content boundingRectWithSize:CGSizeMake(self.contentLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.contentLabel.text = content;
    self.contentLabel.height = nameRect.size.height;
    self.bgView.height = nameRect.size.height + 20;
    self.footerView.height = nameRect.size.height + 20 + 30 + 10;
    self.tableView.tableFooterView = self.footerView;
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
