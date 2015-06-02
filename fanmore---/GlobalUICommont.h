//
//  GlobalUICommont.h
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#ifndef fanmore____GlobalUICommont_h
#define fanmore____GlobalUICommont_h

/**服务器地址*/
#define  MainURL @"http://apitest.fanmore.cn:8080/fanmoreweb/app"

//有盟appKey
#define UMENGID @"52faffcf56240bc21a023179"


//网络请求的固定参数
#define HuoToAppSecret @"1165a8d240b29af3f418b8d10599d0da"  //火图安全网络请求安全协议
//appKey
#define APPKEY @"b73ca64567fb49ee963477263283a1bf"
/**应用版本号*/
#define AppVersion [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]
/**平台*/
#define OPERATION_parame @"FM2015AP"
/**设备唯一号*/
#define  DeviceNo ([[UIDevice currentDevice].identifierForVendor UUIDString])
/**时间*/
#define apptimesSince1970 [NSString stringWithFormat:@"%.0f",[[[NSDate alloc] init] timeIntervalSince1970]]

/**appToken*/
#define AppToken @"AppToken"


#define DWLongitude @"dwLong" //定位精度
#define DWLatitude @"dwLat"   //定位纬度

#define loginUserName  @"username" //用户名
#define loginPassword @"password"  //密码



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



#endif



#ifdef CCQ
#define LWLog(...) NSLog(__VA_ARGS__);
//#define LOG_METHOD NSLog(@&quot;%s&quot;, __func__);
#else
#define LOG(...);
#endif