//
//  CPChargeViewController.m
//  ChargingPile
//
//  Created by RobinLiu on 16/8/29.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPChargeViewController.h"
#import "CPChargeResultViewController.h"
#import "CPChargeProceduceViewController.h"

#import "CPPayViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

#import "ColorUtility.h"
#import "CPAlertView.h"

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface CPChargeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int num;
    int max;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView *bgImageView;
    BOOL isLightOn;
    UILabel * labIntroudction;
    UIView *bgBtn;
    UIImageView *lightIG;
    UIView *bgView1;
    UIView *bgView2;
    UIView *bgView3;
    UIView *bgView4;
}
@property (strong,nonatomic)AVCaptureDevice *lightDevice;
@property (strong,nonatomic)AVCaptureSession * lightSession;
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@end

@implementation CPChargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    [self setView];
#endif

}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.y = _line.y - 1;
        if (_line.y < (bgImageView.y +  5)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.y = _line.y + 1;
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    if(self.preview)
    {
        [self.preview removeFromSuperlayer];
        self.preview = nil;
    }
    if (self.session) {
        [self.session stopRunning];
        self.session = nil;
    }
    if(self.lightSession)
    {
        self.lightSession = nil;
    }
    if(self.device)
    {
        self.device = nil;
    }
    if(self.input)
    {
        self.input = nil;
    }if(self.output)
    {
        self.output = nil;
    }if(self.lightDevice)
    {
        self.lightDevice = nil;
    }
    [self setupCamera];
    [self setLight];
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
    {
        NSString *tip = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleDisplayName"]];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:tip message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [al show];
    }
#endif
}
- (void)setView
{
    self.tableView.hidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
    CGSize btnSize = [UIImage imageNamed:@"dengpao"].size;
    CGFloat space = ((kScreenH - 64 - 49) - 210 - 10 - 50 - btnSize.height)/2.0;
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, space, 210, 210)];
    bgImageView.centerX = kScreenW/2.0;
    bgImageView.image = [UIImage imageNamed:@"二维码扫描框"];
    [self.view addSubview:bgImageView];
    
    upOrdown = NO;
    num = 0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.x + 3, CGRectGetMaxY(bgImageView.frame) - 5, bgImageView.width - 6, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bgImageView.frame) + 10, kScreenW - 40, 50)];
    labIntroudction.numberOfLines=0;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"请将充电端上的二维码图片置于扫描区域内，识别后即可开始充电。";
    [self.view addSubview:labIntroudction];
    
    NSArray *frame1 = @[@0, @0, @(kScreenW), @(bgImageView.y)];
    NSArray *frame2 = @[@0, @(bgImageView.y), @(bgImageView.x), @(bgImageView.height)];
    NSArray *frame3 = @[@(CGRectGetMaxX(bgImageView.frame)), @(bgImageView.y), @(kScreenW - CGRectGetMaxX(bgImageView.frame)), @(bgImageView.height)];
    NSArray *frame4 = @[@0, @(CGRectGetMaxY(bgImageView.frame)), @(kScreenW), @(kScreenH - 64 - 49 - CGRectGetMaxY(bgImageView.frame))];
    
    NSMutableArray *backLocations = [NSMutableArray arrayWithObjects:frame1,frame2,frame3,frame4, nil];
    for (int i=0; i<backLocations.count; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake([backLocations[i][0] doubleValue], [backLocations[i][1] doubleValue], [backLocations[i][2] doubleValue], [backLocations[i][3] doubleValue])];
        backView.backgroundColor = [ColorUtility colorWithRed:1 green:1 blue:1 alpha:0.5];
        [self.view addSubview:backView];
        if(i == 0)
        {
            bgView1 = backView;
        }
        else if (i == 1)
        {
            bgView2 = backView;
        }
        else if (i == 2)
        {
            bgView3 = backView;
        }
        else if (i == 3)
        {
            bgView4 = backView;
        }
    }
    
    bgBtn = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(labIntroudction.frame) + space/4.0, 100, 100)];
    bgBtn.size = btnSize;
    bgBtn.centerX = kScreenW/2.0;
    bgBtn.layer.cornerRadius = bgBtn.width/2.0;
    [self.view addSubview:bgBtn];
    
    lightIG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dengpao"]];
    [bgBtn addSubview:lightIG];
    
    for(UIView *subview in [self.view subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClicked)];
    [bgBtn addGestureRecognizer:tap];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    if (self.session) {
        [self.session stopRunning];
        self.session = nil;
    }
    if(self.lightSession)
    {
        self.lightSession = nil;
    }
    if(self.device)
    {
        self.device = nil;
    }
    if(self.input)
    {
        self.input = nil;
    }if(self.output)
    {
        self.output = nil;
    }if(self.lightDevice)
    {
        self.lightDevice = nil;
    }
#endif
}
- (void)setLight
{
    self.lightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![self.lightDevice hasTorch]) {//判断是否有闪光灯
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alter show];
    }
    isLightOn = NO;
}
- (void)setupCamera
{
    //1.creat device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.creat input device
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    //3.creat output device
    self.output = [[AVCaptureMetadataOutput alloc]init];
    //4.creat session
    self.session = [[AVCaptureSession alloc]init];
    //5.creat layer
    self.preview = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, kScreenW, kScreenH - 64 - 49);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //6.connection device
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }else{
        
        return;
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }else{
        
        return;
    }
    //设置源数据  AVMetadataObjectTypeQRCode 二维码
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    //[self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.output setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    // get result
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    CGRect rect = bgImageView.frame;
    CGRect intertRect = [self.preview metadataOutputRectOfInterestForRect:rect];
   // CGRect layerRect = [self.preview rectForMetadataOutputRectOfInterest:intertRect];
    self.output.rectOfInterest = intertRect;
    
    // start
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session startRunning];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    __block NSNumber *didFind = [NSNumber numberWithBool:NO];
    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *obj, NSUInteger idx, BOOL *stop)
    {
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)obj;
        NSLog(@"Metadata: %@", readableObject);
        if ([NSThread isMainThread]) {
            NSLog(@"Yes Main Thread");
        }
        else {
            NSLog(@"Not main thread");
        }
       // if ([readableObject.stringValue containsString:@"http"])
        if ([readableObject.stringValue length] > 1)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDate *start = [NSDate date];
                [self.session stopRunning];
                [timer invalidate];
                NSLog(@"time took: %f", -[start timeIntervalSinceNow]);
                
                // *** Here is the key, make your segue on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"扫描到的数据 = %@",metadataObjects);
                    NSLog(@"二维码 = %@",readableObject.stringValue);
                    CPPayViewController *payVC = [[CPPayViewController alloc]init];
                    payVC.pileNo = [readableObject.stringValue mutableCopy];
                    [self.navigationController pushViewController:payVC animated:YES];
                    return;
                });
            });
            //NSLog(@"this is a test: %@", getTestName);
           /* didFind = [NSNumber numberWithBool:YES];
            NSLog(@"Found it");
            
            if (metadataObjects.count > 0)
            {
                AVMetadataMachineReadableCodeObject *object = [metadataObjects firstObject];
                NSLog(@"%@",object.stringValue);
                
                 [[CPAlertView sharedInstance]showViewWithTitle:@"温馨提示" andContent:@"读取失败，未知应用" andBlock:^{
                 }];
            }else
            {
                NSLog(@"没有数据");
            }
*/
        }
    }];
    return;
    if ([didFind boolValue]) {
        NSLog(@"Confirming we found it");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDate *start = [NSDate date];
            
         //   [self stopRunning];
            NSLog(@"time took: %f", -[start timeIntervalSinceNow]);
            
            // *** Here is the key, make your segue on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
              //  [self performSegueWithIdentifier:@"segueFromFoundQRCode" sender:self];
               // _labelTestName.text = _testName;
            });
            
        });
    }
    else {
        NSLog(@"Did not find it");
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
}
- (void)btnClicked
{
    //测试
   /* CPPayViewController *payVC = [[CPPayViewController alloc]init];
    payVC.pileNo = @"FFFF7F8F5D0E0AD0";
    [self.navigationController pushViewController:payVC animated:YES];
    return;
    */
    isLightOn = !isLightOn;
    if (isLightOn) {
        [self turnOnLed:YES];
    }else{
        [self turnOffLed:YES];
    }
}
//打开手电筒
-(void) turnOnLed:(bool)update
{
    [self.lightDevice lockForConfiguration:nil];
    [self.lightDevice setTorchMode:AVCaptureTorchModeOn];
    [self.lightDevice unlockForConfiguration];
}

//关闭手电筒
-(void) turnOffLed:(bool)update
{
    [self.lightDevice lockForConfiguration:nil];
    [self.lightDevice setTorchMode: AVCaptureTorchModeOff];
    [self.lightDevice unlockForConfiguration];
}
#pragma mark - 打开手电筒
-(void)openFlashlight
{
    AVCaptureDevice *dev = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (dev.torchMode == AVCaptureTorchModeOff) {
        //Create an AV session
        self.lightSession = [[AVCaptureSession alloc]init];
        
        // Create device input and add to current session
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:dev error:nil];
        [self.lightSession addInput:input];
        
        // Create video output and add to current session
        AVCaptureVideoDataOutput * output = [[AVCaptureVideoDataOutput alloc]init];
        [self.lightSession addOutput:output];
        
        // Start session configuration
        [self.lightSession beginConfiguration];
        [dev lockForConfiguration:nil];
        
        // Set torch to on
        [dev setTorchMode:AVCaptureTorchModeOn];
        
        [dev unlockForConfiguration];
        [self.lightSession commitConfiguration];
        
        // Start the session
        [self.lightSession startRunning];
        
        // Keep the session around
        //[self setAVSession:self.session];
    }
}

-(void)closeFlashlight
{
    [self.lightSession stopRunning];
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
