//
//  AppDelegate.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <INTULocationManager.h>//定位
#import "LoginResultData.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
//#import "WeiboApi.h"
#import "WeiboSDK.h"
//#import <RennSDK/RennSDK.h>
#import <AlipaySDK/AlipaySDK.h>  //支付宝接入头文件
#import "LWNewFeatureController.h"



@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationIconBadgeNumber = 0;
    
    
    
    //集成第三方
    [self setupThreeApp];
    
    
    //定位功能
    [self setupLocal];
   
    
    //进行初始化借口调用
    [self setupInit];
    
    
    NSString * appVersion = [[NSUserDefaults standardUserDefaults] stringForKey:LocalAppVersion];
    NSLog(@"aaaa%@",appVersion);
    if (appVersion) {
        
        if ([appVersion isEqualToString:AppVersion]) {//相等
            RootViewController * roots = [[RootViewController alloc] init];
            self.window.rootViewController = roots;
            [self.window makeKeyAndVisible];
            
        }else{//不相等
            [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:LocalAppVersion];
            LWNewFeatureController *new = [[LWNewFeatureController alloc] init];
            self.window.rootViewController = new;
            [self.window makeKeyAndVisible];
        }
        
    }else{//没有版本号
        //
        [[NSUserDefaults standardUserDefaults] setObject:AppVersion forKey:LocalAppVersion];
        LWNewFeatureController *new = [[LWNewFeatureController alloc] init];
        self.window.rootViewController = new;
        [self.window makeKeyAndVisible];
    }
    
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"浙A99981");
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    
    //APNS
    [self registRemoteNotification:application];
    
    return YES;
    
    
}




/**
 *  获取deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"苹果apns返回的deviceToken%@",deviceToken);
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (notification) {
        NSLog(@"%@",notification);
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:nil message:@"received E-mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

/**
 *  支付宝支付成功返回
 *
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    return YES;
}

/**
 *  调用程序初始化接口
 *
 *  @return falure 就token不通
 */
- (void)setupInit{
    
    //出使化网络
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appSecret"] = HuoToAppSecret;
    params[@"appKey"] = APPKEY;
    NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
    NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
    NSLog(@"lat = %@  log = %@",lat,lng);
    params[@"lat"] = @(116.0);
    params[@"lng"] =@(40.0);
    params[@"timestamp"] = apptimesSince1970;
    params[@"operation"] = OPERATION_parame;
    params[@"version"] = AppVersion;
    NSString * aaatoken = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
    NSLog(@"aaatoken === %@",aaatoken);
    params[@"token"] = aaatoken?aaatoken:@"";
    params[@"imei"] = DeviceNo;
    params[@"cityCode"] = @"123";
    params[@"cpaCode"] = @"default";
    params[@"sign"] = [NSDictionary asignWithMutableDictionary:params];
    [params removeObjectForKey:@"appSecret"];
    NSLog(@"init---prame===%@",params);
    
    //网络请求借口
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"init"];
    __block LoginResultData * resultData = [[LoginResultData alloc] init];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        
        NSLog(@"init 借口返回的数据%@",responseObject);
        
        if ([responseObject[@"systemResultCode"] intValue] == 1 && [responseObject[@"resultCode"] intValue] == 1) {//返回数据成功
            
            
            
            resultData = [LoginResultData objectWithKeyValues:responseObject[@"resultData"]];//数据对象话
            NSLog(@"%@",responseObject[@"resultData"]);
            
            //保存答题能阅读的时间
            [[NSUserDefaults standardUserDefaults] setObject: @(resultData.global.lessReadSeconds) forKey:AppReadSeconds];

            //取出本地token
            NSString *localToken = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
            NSLog(@"zzzzzzzzzzzzzzzzzzzzzzz%@",localToken);
            NSLog(@"zzzzzzzzzzzzzzzzzzzzzzz%@",resultData.user.token);
            if (![localToken isEqualToString:resultData.user.token]) {
                //保存新的token
                [[NSUserDefaults standardUserDefaults] setObject:resultData.user.token forKey:AppToken];
                NSString * flag = @"wrong";
                [[NSUserDefaults standardUserDefaults] setObject:flag forKey:loginFlag];
                
                NSLog(@"zzzzzzzzzzzzzzzzzzzzzzz%@",[[NSUserDefaults standardUserDefaults] objectForKey:AppToken]);
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                //1、保存全局信息
                NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
                [NSKeyedArchiver archiveRootObject:resultData.global toFile:fileName]; //保存用户信息
                
            }else{
                NSString * flag = @"right";
                [[NSUserDefaults standardUserDefaults] setObject:flag forKey:loginFlag];
                //初始化
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                //1、保存个人信息
                NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                [NSKeyedArchiver archiveRootObject:resultData.user toFile:fileName]; //保存用户信息
                //2、保存全局信息
                fileName = [path stringByAppendingPathComponent:InitGlobalDate];//保存全局信息
                [NSKeyedArchiver archiveRootObject:resultData.global toFile:fileName]; //保存用户信息
                
                
            }
        }else{
            
            NSLog(@"网络请求出错了。。。。。。。。。。。。。。。。");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"xxxxxxx=%@",error.description);
    }];

   
}

//添加滑动的手势
- (void)handleSwipes22:(UISwipeGestureRecognizer *)sender{
    [self.deckController toggleRightViewAnimated:YES];
}

/**
 *  集成第三方
 */
- (void)setupThreeApp{
    
    /**微信支付*/
    [WXApi registerApp:WeiXinAppID withDescription:@"fanmore--3.0.0"]; //像微信支付注册
    
    //    *友盟*
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:nil];
    [MobClick setCrashReportEnabled:YES];
    //    *友盟注册*
    
    /**shareSdK*/
    [ShareSDK registerApp:ShareSDKAppKey];//字符串api20为您的ShareSDK的AppKey
    //3添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:XinLangAppkey
                               appSecret:XinLangAppSecret
                             redirectUri:XinLangRedirectUri];
    //4添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQAppKey
                           appSecret:QQappSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //5微信登陆的时候需要初始化
    [ShareSDK connectWeChatTimelineWithAppId:@"WeiXinAppKey"
                                   appSecret:@"8c3b660de36a3b3fb678ca865e31f0f3"
                                   wechatCls:[WXApi class]];
    /**shareSdK*/
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    
}

/**
 *  开启定位功能
 */
- (void)setupLocal{
    /**定位*/
    INTULocationManager * locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:20 delayUntilAuthorized:YES     block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            NSLog(@"定位成功纬度 %f 精度%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
            NSString * lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
            NSString * lg = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
            [[NSUserDefaults standardUserDefaults] setObject:lat forKey:DWLatitude]; //保存纬度
            [[NSUserDefaults standardUserDefaults] setObject:lg forKey:DWLongitude];//保存精度
        }
        else{
            [MBProgressHUD showError:@"定位失败"];
        }
        
    }];
}


/**
 *  注册远程通知
 */
- (void)registRemoteNotification:(UIApplication *)application{
    if (IsIos8) { //iOS 8 remoteNotification
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }else{
        
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [application registerForRemoteNotificationTypes:type];
        
    }
}
@end
