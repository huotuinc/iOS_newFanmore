//
//  GlobalUICommont.h
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//  cs啊

#ifndef fanmore____GlobalUICommont_h
#define fanmore____GlobalUICommont_h

/**服务器地址*/
#define  MainURL @"http://apitest.51flashmall.com:8080/fanmoreweb/app"
//@"http://192.168.0.19:8080/fanmoreweb/app"
//@"http://apitest.51flashmall.com:8080/fanmoreweb/app"
//@"http://192.168.0.14:8080/fanmoreweb/app"
//http://192.168.0.14:8080/fanmoreweb/
//@"http://apitest.51flashmall.com:8080/fanmoreweb/app"
//192.168.0.14



/**微信支付*/
#define WeiXinAppID @"wxadee5477e854a778"
#define WeiXinppSecrrt @"8ad99de44bd96a323eb40dc161e7d8e8"
#define WeiXinPaySigNkey @"NzfP6pfeljyHeY08LO9p8YAKZCGLz8akO4lCGdXZOGnVsJqfo8jeuYB7C0GoFJGEKZMDVGKWYnbbJj3pCpvJzd4iY7bVglaNz54XAD26tiCr5DZGLjZFoRxbqe8i3HT5"
#define WeiXinPARTNERKEY @"18076bf2a8bf9479f2cddeec13fd2ec0"
#define WeiXin @"1220397601"

//有盟appKey
#define UMAppKey @"52faffcf56240bc21a023179"


/**shareSDK */
#define ShareSDKAppKey @"19b4b4d45192"
/**新浪微博*/
#define XinLangAppkey @"1994677353"
#define XinLangAppSecret @"0783d8dd1f0eb5a45687cde79aa10108"
#define XinLangRedirectUri @"https://api.weibo.com/oauth2/default.html"
/**QQ**/
#define QQAppKey @"101066212"
#define QQappSecret @"09ef5bfed097b682a83b147d46e46a5a"
/**微信*/
#define WeiXinAppKey @"wxadee5477e854a778"
/**shareSDK */


//网络请求的固定参数
#define HuoToAppSecret @"1165a8d240b29af3f418b8d10599d0da"  //火图安全网络请求安全协议
//appKey
#define APPKEY @"b73ca64567fb49ee963477263283a1bf"
/**应用版本号*/
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/**本地存储的版本号*/
#define LocalAppVersion @"LocalAppVersion"
/**平台*/
#define OPERATION_parame @"FM2015AP"
/**设备唯一号*/
#define  DeviceNo ([[UIDevice currentDevice].identifierForVendor UUIDString])
/**时间*/
#define apptimesSince1970 [NSString stringWithFormat:@"%.0f",([[[NSDate alloc] init] timeIntervalSince1970]*1000)]

/**appToken*/
#define AppToken @"AppToken"


#define DWLongitude @"dwLong" //定位精度
#define DWLatitude @"dwLat"   //定位纬度

#define loginUserName  @"username" //用户名
#define loginPassword @"password"  //密码
#define loginFlag @"loginFlag"  // 是否需要等人标志

#define UserLoginNumber [NSUserDefaults standardUserDefaults] stringForKey:@"username"]

//网络请求的固定参数

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height //屏幕宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width   //屏幕高度
//判断ios7
#define IsIos7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
//判断ios8
#define IsIos8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
// RGB颜色
#define LWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/**注册宏*/
#define PHONENUMBERLENGTH 11   //手机号长度
#define VERIFICATIONCODELENGTH 6  //验证码长度
#define FanMoreDB @"fanMoreDB"  //粉猫数据库
#define TaskDataTable @"taskDataTable" //任务数据库任务表
#define UserIconView @"appIconView"    //用户头像

#define AppReadSeconds  @"lessReadSeconds"  //点击答题时倒记时

#define InitResultDate @"initResultDate"    //初始化返回数据对象
#define InitGlobalDate @"initGlobalDate"    //初始化返回的global
#define LocalUserDate @"loginUserDate"  //登入绑定返回的用户数据


#define TodaySignNot @"TodaySignNot"   //签到推送通知类型

#endif



#ifdef CCQ
#define LWLog(...) NSLog(__VA_ARGS__);
//#define LOG_METHOD NSLog(@&quot;%s&quot;, __func__);
#else
#define LOG(...);
#endif