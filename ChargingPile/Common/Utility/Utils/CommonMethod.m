/*!
 版本号   v1.0
 版本说明 初步建立
 作者    rui.yang
 模块功能 通用的一些方法
 主要函数 
 */

#import "CommonMethod.h"

@implementation CommonMethod


//显示提示
+(void)showMesg:(NSString *)nssMesg
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:nssMesg
                        message:@""
                        delegate:self
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:nil];
    alert.tag = 91;
    [alert show];
}
+(void)showMesgWithTitle:(NSString *)title andMsg:(NSString *)nssMesg
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:title
                        message:nssMesg
                        delegate:self
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:nil];
    alert.tag = 91;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}

+ (void)showMesg:(NSString *)nssMesg
	 withDelegate:(id <UIAlertViewDelegate>)aDelegate
				 withTag:(int)tag
{
	NSString *nssMessage=nssMesg;
	UIAlertView *alert=[[UIAlertView alloc]
											initWithTitle:@"温馨提示"
											message:nssMessage
											delegate:aDelegate
											cancelButtonTitle:@"知道了"
											otherButtonTitles:nil];
	alert.tag = tag;
	[alert show];
}

//url处理
+(NSURL *)smartURLForString:(NSString *)str
{
	NSURL *result;
	NSString *trimmedStr;
	NSRange schemeMarkerRang;
	NSString *scheme;
	
	if (str == nil) return nil;
	result = nil;
	
	trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ((trimmedStr != nil) && (trimmedStr.length != 0)) {
		schemeMarkerRang = [trimmedStr rangeOfString:@"://"];
		
		if (schemeMarkerRang.location == NSNotFound) {
			result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",trimmedStr]];
		}
		else {
			scheme = [trimmedStr substringWithRange:NSMakeRange(0,schemeMarkerRang.location)];
			assert(scheme != nil);
			if (([scheme compare:@"http" options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame)) 
			{
				result = [NSURL URLWithString:trimmedStr];
			}
			else {
				
			}
		}
	}
	return result;
}
//pdf处理相关
/*********************************************
 *加密解密相关参数
 ********************************************/
+(NSString *)getPDFEncryptKey:(NSString *)nsPDFName
{
	//NSString * nsPDFEncryptKey = @"";
	const char  *lpBuffFileName = [nsPDFName UTF8String];
	char   lpBuffUserKey[10+1] ;
	//char * lpSrcKey="wuxicnki";        //8位长
	//char * lpMarstKey="wuxizazhi2011"; //masterkey
	int  lpSrcKeyLen = 10;
	for(int k=0;k<lpSrcKeyLen;k++)
	{
		int intA = 'a';
		int intZ = 'z';
		int lpbFNK = lpBuffFileName[k];
		lpBuffUserKey[k]=intA +
		(lpbFNK)%(intZ+1 - intA);
	}
	lpBuffUserKey[lpSrcKeyLen] = '\0';
    
	NSString * nsPDFEncryptFinalKey = [NSString stringWithUTF8String:lpBuffUserKey];
	return nsPDFEncryptFinalKey;
}
/*获取主目录*/
+(NSString*)getMainFileDrectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString * nssFinalDocPath = [NSString stringWithFormat:@"%@/",documentsDir];
    return nssFinalDocPath;
}
/*根据bookid获取相关的文件路径*/
+(BOOL)getIsFileExist:(NSString*)nssBookId
{
    BOOL bIsExist = NO;
    
    NSString * nssFinalFilePath = [CommonMethod getFileDownPath:nssBookId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    bIsExist = [fileManager fileExistsAtPath:nssFinalFilePath isDirectory:&isDir];
    return bIsExist;
}
/*获取下载路径*/
+(NSString*)getFileDownPath:(NSString*)nssBookId
{
    NSString * nssMainFileDrectory = [CommonMethod getMainFileDrectory];
    NSString * nssFinalDownPath = [NSString stringWithFormat:@"%@%@",
                                   nssMainFileDrectory,nssBookId];
    return nssFinalDownPath;
}
/*获取临时路径*/
+(NSString*)getFileDownTempPath:(NSString*)nssBookId
{
    NSString * nssFinalDownName = [NSString stringWithFormat:@"%@.down",nssBookId];
    NSString * nssMainFileDrectory = [CommonMethod getMainFileDrectory];
    NSString * nssFinalDownPath = [NSString stringWithFormat:@"%@%@",
                                   nssMainFileDrectory,nssFinalDownName];
    return nssFinalDownPath;
}
//截断小数点
+(NSString*)getPriceCutOff:(NSString*)_nssPrice
{
    NSString * nssSrcPrice = _nssPrice;
    NSString * nssDes = @"";
    if (nssSrcPrice == nil) {
        nssDes = nil;
    }
    else
    {
        int intLength = (int)[nssSrcPrice length];
        NSRange nsrDote = [nssSrcPrice rangeOfString:@"."];
        //找到了
        if (nsrDote.length !=0) {
            if (intLength-1>=nsrDote.location + 2) {
                NSRange range;
                range.location =0;
                range.length = nsrDote.location+2+1;
                nssDes = [nssSrcPrice substringWithRange:range];
            }
            else
            {
                nssDes = nssSrcPrice;
            }
        }
        //没有找到
        else{
            nssDes = nssSrcPrice;
        }
    }
    return nssDes;
}

//获取当前屏幕是横竖屏
+(BOOL)getCurScreenIsPotrait
{
    BOOL isPortrait = NO;

    UIInterfaceOrientation curInterfaceOrientation =
        [UIApplication sharedApplication].statusBarOrientation;
    if (curInterfaceOrientation == UIInterfaceOrientationPortrait 
        || curInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
    {
        //竖屏
        isPortrait = YES;
    }
    else if(curInterfaceOrientation == UIInterfaceOrientationLandscapeLeft 
            || curInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        //横屏
        isPortrait = NO;
    }
    
    return isPortrait;
}


/*!获取提示信息*/
+(NSString*)getMsgFromCode:(int)aErrorCode
{
    NSString * aMsg = @"";
    switch (aErrorCode)
    {
        case -1:
            aMsg = @"请求参数错误";
            break;
        case 0:
            aMsg = @"空记录";
            break;
        case 1:
            aMsg = @"加密错误";
            break;
        case 2:
            aMsg = @"服务器错误";
            break;
        case 3:
            aMsg = @"金额不足";
            break;
        case 4:
            aMsg = @"已购买";
            break;
        default:
            break;
    }
    return aMsg;
}

+(NSString*)handleError:(NSString*) str
{
    NSString * result  = nil;
    while (true)
    {
    }
    return result;
}


+ (uint) detectDevice
{
    NSString *model= [[UIDevice currentDevice] model];
    
    // Some iPod Touch return "iPod Touch", others just "iPod"
    
    NSString *iPodTouch = @"iPod Touch";
    NSString *iPodTouchLowerCase = @"iPod touch";
    NSString *iPodTouchShort = @"iPod";
    NSString *iPad = @"iPad";
    
    NSString *iPhoneSimulator = @"iPhone Simulator";
    
    uint detected;
    // iPhone simulator
    if ([model compare:iPhoneSimulator] == NSOrderedSame)
    {
        detected = MODEL_IPHONE_SIMULATOR;
    }
    else if ([model compare:iPad] == NSOrderedSame)
    {
        // iPad
        detected = MODEL_IPAD;
    }
    else if ([model compare:iPodTouch] == NSOrderedSame)
    {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    }
    else if ([model compare:iPodTouchLowerCase] == NSOrderedSame)
    {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    }
    else if ([model compare:iPodTouchShort] == NSOrderedSame)
    {
        // iPod Touch
        detected = MODEL_IPOD;
    } else
    {
        // Could be an iPhone V1 or iPhone 3G (model should be "iPhone")
        struct utsname u;
        
        // u.machine could be "i386" for the simulator, "iPod1,1" on iPod Touch, "iPhone1,1" on iPhone V1 & "iPhone1,2" on iPhone3G
        
        uname(&u);
        
        if (!strcmp(u.machine, "iPhone1,1"))
        {
            detected = MODEL_IPHONE;
        } 
        else 
        {
            detected = MODEL_IPHONE_3G;
        }
    }
    return detected;
}

+ (BOOL)isIphone
{
    int model = [self detectDevice];
    if (model == MODEL_IPHONE || model == MODEL_IPHONE_3G)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+(void)telPhone:(NSString *)num
{
    {
        //telprompt:有弹出框,呼叫后并返回;tel:直接呼叫,不能返回.
        if (![self isIphone])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"该设备不支持电话功能"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            BOOL res = [[UIApplication sharedApplication] openURL:
                        [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",num]]];
            if (!res)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示信息"
                                      message:@"不是有效的电话号码"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }
}

+(void)sendEmail:(NSString*)add
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",add]]];
}

+(void)openSite:(NSString*)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url]]];
}

// 字符串时间转date
+ (NSDate *)getStringDate:(NSString *)str
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:str];
}

/** 获取当前时间**/
+(NSString*)getCurrentTime
{
    NSString* nsCurrentTime;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    nsCurrentTime = [formatter stringFromDate:[NSDate date]];
    return nsCurrentTime;
}

+ (NSString*)getTimeWithFormatter:(NSString *)str
{
    NSString* nsCurrentTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:str];
    nsCurrentTime = [formatter stringFromDate:[NSDate date]];
    return nsCurrentTime;
}


+ (NSString *)getCurDateStr
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

/** push到某个界面*/
+(BOOL)pushHistoryViewController:(UINavigationController*)aNavigationController
                 WithToViewController:(Class)aViewControllerClass
{
    if(![aViewControllerClass isSubclassOfClass:[UIViewController class]])
    {
        return NO;
    }
    
    NSArray * viewControllers = [aNavigationController viewControllers];
    
    UIViewController * searchControler = nil;
    for (int i =0 ; i<[viewControllers count]; i++)
    {
        UIViewController * aController = [viewControllers objectAtIndex:i];
        if([aController isKindOfClass:aViewControllerClass])
        {
            searchControler = aController;
            break;
        }
    }
    
    if(searchControler != nil)
    {
        [aNavigationController popToViewController:searchControler
                                              animated:YES];
    }
    else
    {
        searchControler = [[aViewControllerClass alloc] init];
        [aNavigationController pushViewController:searchControler
                                             animated:YES];
    }
    
    return YES;
}

+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    

    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];

    return destDateString;
    
}


+ (NSDate *)dateFromString:(NSString *)dateString WithParseStr:(NSString*)paseStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: paseStr];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(int)weekDayFromDate:(NSDate*)aDate
{
    int weekday =0;
    if(aDate == nil)
    {
        weekday = 0;
    }
    else
    {
        NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar]
                                       components:NSWeekdayCalendarUnit fromDate:aDate];
        weekday = (int)[componets weekday];
    }

    return weekday;
}

+(NSString*)getWeekDayFromInt:(int)weekDay
{
    if(weekDay<1 || weekDay>7)
        return @"";
    switch (weekDay)
    {
        case 1:
            return @"日";
            break;
        case 2:
            return @"一";
            break;
        case 3:
            return @"二";
            break;
        case 4:
            return @"三";
            break;
        case 5:
            return @"四";
            break;
        case 6:
            return @"五";
            break;
        case 7:
            return @"六";
            break;
        default:
            return @"";
            break;
    }
}

+(NSDate*)getTheDayBefore:(NSDate*)adate
{
    NSDate *newDate = [[NSDate alloc]
                       initWithTimeIntervalSinceReferenceDate:
                       ([adate timeIntervalSinceReferenceDate] - 24*3600)];
    return newDate;
}

+(NSDate*)getTheDayAfter:(NSDate*)adate
{
    NSDate *newDate = [[NSDate alloc]
                       initWithTimeIntervalSinceReferenceDate:
                       ([adate timeIntervalSinceReferenceDate] + 24*3600)];
    return newDate;
}

//邮箱验证
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
