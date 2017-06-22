/*!
 版本号   v1.0
 版本说明 初步建立
 作者    rui.yang
 模块功能 通用的一些方法
 主要函数 
 */

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import <sys/utsname.h>
//#import "ticketReserveViewController.h"
/*!
 @enum
 @abstract IOS各种设备
 @constant
 */
enum {
    MODEL_IPHONE_SIMULATOR,
    MODEL_IPOD_TOUCH,
    MODEL_IPOD,
    MODEL_IPHONE,
    MODEL_IPHONE_3G,
    MODEL_IPHONE_4,
    MODEL_IPHONE_4S,
    MODEL_IPHONE_5,
    MODEL_IPOD_TOUCH5,
    MODEL_IPAD,
    MODEL_IPAD2
};

@interface CommonMethod : NSObject<UIAlertViewDelegate>
/**
 * 获取当前的设备型号
 */
+ (uint)detectDevice;
//消息提示
+(void)showMesg:(NSString *)nssMesg;
+(void)showMesgWithTitle:(NSString *)title andMsg:(NSString *)nssMesg;

//url 处理
+(NSURL *)smartURLForString:(NSString *)str;
//pdf处理相关
+(NSString*)getPDFEncryptKey:(NSString*)nssFileName;
/*获取主目录*/
+(NSString*)getMainFileDrectory;
/*根据bookid获取相关的文件路径*/
+(BOOL)getIsFileExist:(NSString*)nssBookId;
/*获取下载路径*/
+(NSString*)getFileDownPath:(NSString*)nssBookId;
/*获取临时路径*/
+(NSString*)getFileDownTempPath:(NSString*)nssBookId;

//截断小数点
+(NSString*)getPriceCutOff:(NSString*)_nssPrice;

/*!
 函数功能 获取当前屏幕是横竖屏
 输入参数 void 
 返回值   BOOL,YES 是树屏，NO，是横屏
 */
+(BOOL)getCurScreenIsPotrait;

/*!获取提示信息*/
+(NSString*)getMsgFromCode:(int)aErrorCode;

/** 容错*/
+(NSString*)handleError:(NSString*) str;

+(void)telPhone:(NSString*)num;

+(void)sendEmail:(NSString*)add;

+(void)openSite:(NSString*)url;

+ (void)showMesg:(NSString *)nssMesg
		withDelegate:(id <UIAlertViewDelegate>)aDelegate
				 withTag:(int)tag;

/** 获取当前时间**/
+(NSString*)getCurrentTime;

+(NSString *)getCurDateStr;

+(NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)getStringDate:(NSString *)str;

/** push到某个界面*/
+(BOOL)pushHistoryViewController:(UINavigationController*)aNavigationController
                 WithToViewController:(Class)aViewControllerClass;

/** 字符串转换成NSData类型*/
+ (NSDate *)dateFromString:(NSString *)dateString WithParseStr:(NSString*)paseStr;

+(int)weekDayFromDate:(NSDate*)aDate;

+(NSString*)getWeekDayFromInt:(int)weekDay;

+(NSDate*)getTheDayBefore:(NSDate*)adate;

+(NSDate*)getTheDayAfter:(NSDate*)adate;

+ (NSString*)getTimeWithFormatter:(NSString *)str;

/** 字符串转换成NSData类型*/

//邮箱验证
+(BOOL)isValidateEmail:(NSString *)email;
@end
