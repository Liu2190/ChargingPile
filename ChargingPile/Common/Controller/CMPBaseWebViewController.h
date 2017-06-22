//
//  CMPBaseWebViewController.h
//  chargingPile
//
//  Created by RobinLiu on 15/9/24.
//  Copyright © 2015年 chargingPile. All rights reserved.
//

#import "CPBaseTableViewController.h"

@interface CMPBaseWebViewController : CPBaseTableViewController
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *webViewUrl;
@end
