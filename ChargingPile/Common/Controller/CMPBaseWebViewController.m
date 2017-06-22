//
//  CMPBaseWebViewController.m
//  chargingPile
//
//  Created by RobinLiu on 15/9/24.
//  Copyright © 2015年 chargingPile. All rights reserved.
//

#import "CMPBaseWebViewController.h"

@interface CMPBaseWebViewController ()<UIWebViewDelegate>
@end

@implementation CMPBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.hidden = YES;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    self.webView.delegate = self;
    self.webView.frame = self.tableView.frame;
    [self.view addSubview:self.webView];
    self.webViewUrl = (NSMutableString *)[self.webViewUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewUrl]];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}
- (void)leftMenuClick
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    self.title = @"加载失败";
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
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
