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



@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    NSString * adasdas= [[NSUserDefaults standardUserDefaults] objectForKey:<#(NSString *)#>];
//    NSLog(@"local ===%@",adasdas);
    
//    *友盟*
    [MobClick startWithAppkey:UMENGID reportPolicy:BATCH channelId:nil];
    [MobClick setCrashReportEnabled:YES];
//    *友盟注册*
    
    /**shareSdK*/
    //1、连接短信分享
    [ShareSDK connectSMS];
    //2、连接邮件
    [ShareSDK connectMail];
    
    [ShareSDK registerApp:@"api20"];//字符串api20为您的ShareSDK的AppKey
    
    //3添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:APPKEY
                               appSecret:@"0783d8dd1f0eb5a45687cde79aa10108"
                             redirectUri:@"http://www.sharesdk.cn"];
    //3当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:APPKEY
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    //4添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:APPKEY
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //4添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:APPKEY
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //5添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           wechatCls:[WXApi class]];
    //5微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    /**shareSdK*/
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
    
    //进行初始化借口调用
    [self setupInit];
    
    //
    RootViewController * roots = [[RootViewController alloc] init];
    self.window.rootViewController = roots;
    [self.window makeKeyAndVisible];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"浙A99981");
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    
    return YES;
    
    
}


/**
 *  返回值token比较值
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
    params[@"version"] = [NSString stringWithFormat:@"%f",AppVersion];
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
            
            
//            //保存答题能阅读的时间
//            [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%d",resultData.global.lessReadSeconds] forKey:AppReadSeconds];
//            
//            //保存答题能阅读的时间
//            [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%d",resultData.global.amountToCheckout] forKey:AppReadSeconds];
            
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:resultData.user toFile:fileName];
            
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
            }else{
                
                NSString * flag = @"right";
                [[NSUserDefaults standardUserDefaults] setObject:flag forKey:loginFlag];
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (notification) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:nil message:@"received E-mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
