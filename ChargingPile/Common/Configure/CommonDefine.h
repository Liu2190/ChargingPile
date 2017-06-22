//
//  CommonDefine.h
//  chargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#ifndef sbh_CommonDefine_h
#define sbh_CommonDefine_h

#define kAppID @"1044974581"
#define kAmapAPIKey @"b781dd407a255b4e39aba590b25e16c1"

//allNotifications
//log & register & modifyPassword
#define kNotificationLoginSuccess @"UserLoginIn"
#define kNotificationLoginFail @"UserLoginFail"
#define kNotificationLoginCancel @"UserLoginCancel"
#define kNotificationLogOffSuccess @"UserLogOff"
#define kNotificationWillLogOff @"userWillLogOff"
#define kNotificationModifyPwSuccess @"modifyPWSuccess"
#define kNotificationModifyPwFail @"modifyPWFail"
#define kNotificationRegisterSuccess @"registerSuccess"
#define kNotificationRegisterFail @"registerFail"

//下载头像成功
#define kNotificationDownloadHeaderSuccess @"NotificationDownloadHeaderSuccess"
//上传头像成功
#define kNotificationUploadHeaderSuccess @"NotificationUploadHeaderSuccess"
//修改用户信息成功
#define kNotificationUpdateUserInfoSuccess @"NotificationUpdateUserInfoSuccess"

//充值成功
#define kNotificationChargeSuccess @"notificationChargeSuccess"

//电桩
#define kNotificationRightButtonItem @"RightButtonItem"
#define kNotificationLeftButtonItem @"LeftButtonItem"
#define kNotificationSearchKeywords @"NotificationSearchKeywords"

#define kLeftItemCityName @"leftItemCityName"
//评论成功
#define kNotificationCommentSuccess @"NotificationCommentSuccess"


//下载动态列表图片成功
#define kNotificationDownloadDynamicListSuccess @"NotificationDownloadDynamicListSuccess"

//ErrorCode
#define kErrCodeNetWorkUnavaible 111   //NetWorkUnavaible
#define kHttpRequestCancelledError 99 // http请求被主动cancelled返回的错误

//CommonDefine
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kIs_iPhone4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define kIs_iPhone5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define kIs_iPhone6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define kIs_iPhone6Plus (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)
#define kIs_iOS7 (([[UIDevice currentDevice].systemVersion doubleValue]>=7.0 &&[[UIDevice currentDevice].systemVersion doubleValue]<8.0)?YES : NO)
#define kIs_iOS8 (([[UIDevice currentDevice].systemVersion doubleValue]>=8.0 &&[[UIDevice currentDevice].systemVersion doubleValue]<9.0)?YES : NO)

//关于登录的msg
#define kLoginPushedOffMsg @"下线通知，您的账号已在其他地方登录！"
#define kAgainLoginMsg @"登录已失效，请重新登录！"
#define kUnLoginMsg @"您还未登录，请登录"

//ad
#define kNotificationShowAd             @"showADPage"
#define kNotificationGuidePageDisappear @"GuidePageDisappear"
//msg
#define kNotificationMsgUpdate          @"NewMsgUpdate"
#define kNotificationAddHotelPerson     @"AddHotelPerson"

//jpush
#define kRegisterJPushNotification      @"registerJPush"
#define kFailRegisterRemoteNotification @"FailRegisterJPush"

//最近的登录用户
#define kLatestLoginUserAccount         @"LatestLoginUserAccount"
//最近充电的orderId
#define kLatestChargeOrderId         @"LatestChargeOrderId"
#define kAdPageDataKey                  @"AdPageDataKey"
#define kIsAdPageShowed                 @"isAdPageShowed"




#define kOrderListCellFont [UIFont systemFontOfSize:14]
#define kContentSmallCellFont [UIFont systemFontOfSize:12]

#endif
