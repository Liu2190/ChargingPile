//
//  WeBaseTableViewController.h
//  ChargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableView.h"
#import "CommonDefine.h"

@interface CPBaseTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic,assign)UITableViewStyle tableViewStyle;
@property (nonatomic,strong)BaseTableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

- (void)leftMenuClick;
-(UIViewController *)getNavigationHistoryVC:(Class) aVcClass;
@end
