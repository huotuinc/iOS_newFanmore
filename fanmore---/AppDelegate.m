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
#import "detailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
//#import "WeiboApi.h"
#import "WeiboSDK.h"
//#import <RennSDK/RennSDK.h>
#import <AlipaySDK/AlipaySDK.h>  //支付宝接入头文件
#import "LWNewFeatureController.h"
#import <CoreLocation/CoreLocation.h> //定位
#import "NSData+NSDataDeal.h"




@interface AppDelegate ()

@property(nonatomic,strong) CLLocationManager *mgr;

@property(nonatomic, strong) NSMutableString *taskId;


/**apns*/
@property(nonatomic,strong) NSString * deviceToken;
@end

@implementation AppDelegate


- (CLLocationManager *)mgr{
    
    if (_mgr == nil) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //定位
    [self test];
    
    
    application.applicationIconBadgeNumber = 0;
    
    
    
    //集成第三方
    [self setupThreeApp];
    
    
    //定位功能
//    [self setupLocal];
   
    
    //进行初始化借口调用
    [self setupInit];
    
    
    NSString * appVersion = [[NSUserDefaults standardUserDefaults] stringForKey:LocalAppVersion];
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
    
    
//    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    NSDictionary *userInfo1 = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    NSLog(@"%@",launchOptions);
    if (launchOptions) {
        
        NSNotification *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (dic) {
            self.taskId = dic.userInfo[@"id"];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.taskId forKey:@"taskId"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:ReciveTaskId object:nil userInfo:userInfo];
            });
            
        }
        
        NSNotification *dicRemote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dicRemote) {
            switch ((int)dicRemote.userInfo[@"type"]) {
                case 1:
                    break;
                case 2:
                    break;
                case 3:
                    break;
                case 4:
                    break;
                case 5:
                    break;
                case 6:
                    break;

                default:
                    break;
            }
            
            
//            NSLog(@"self.userInfo:: %@", self.userInfo);
//            NSLog(@"!!!!CCCCC:::%@",dic.userInfo);
//            UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@活动开始了", self.userInfo[@"title"]] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
//            [ac show];
        }
        
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
 *  ios8 远程通知方法
 *
 *  @param application       <#application description#>
 *  @param userInfo          <#userInfo description#>
 *  @param completionHandler <#completionHandler description#>
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你关注的活动开始了"] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
    [ac show];
    [application completeStateRestoration];
    
}

/**
 *  ios7 远程通知方法
 *
 *  @param application <#application description#>
 *  @param userInfo    <#userInfo description#>
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你关注的活动开始了"] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
    [ac show];
}


-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}

/**     
 *  获取deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString * aa = [deviceToken hexadecimalString];
    NSLog(@"%@",aa);
    
    NSString * urlstr = [MainURL stringByAppendingPathComponent:@"updateDeviceToken"];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"deviceToken"] = aa;
    [UserLoginTool loginRequestGet:urlstr parame:parame success:^(id json) {
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (notification) {
        application.applicationIconBadgeNumber = 0;
//        [self.userInfo removeAllObjects];
//        [self.userInfo addEntriesFromDictionary:notification.userInfo];
        UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你关注的活动开始了"] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
        [ac show];
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
//                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    
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
//    NSLog(@"lat = %@  log = %@",lat,lng);
    params[@"lat"] = ([lat isEqualToString:@""]?(@(116.0)):(@([lat floatValue])));
    params[@"lng"] = ([lng isEqualToString:@""]?(@(116.0)):(@([lng floatValue])));
    params[@"timestamp"] = apptimesSince1970;
    params[@"operation"] = OPERATION_parame;
    params[@"version"] = AppVersion;
    NSString * aaatoken = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
    params[@"token"] = aaatoken?aaatoken:@"";
    params[@"imei"] = DeviceNo;
    params[@"cityCode"] = @"123";
    params[@"cpaCode"] = @"default";
    params[@"sign"] = [NSDictionary asignWithMutableDictionary:params];
    [params removeObjectForKey:@"appSecret"];
    
    
    //网络请求借口
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"init"];
    __block LoginResultData * resultData = [[LoginResultData alloc] init];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"systemResultCode"] intValue] == 1 && [responseObject[@"resultCode"] intValue] == 1) {//返回数据成功
            
            
            
            resultData = [LoginResultData objectWithKeyValues:responseObject[@"resultData"]];//数据对象话
            
            //保存答题能阅读的时间
            [[NSUserDefaults standardUserDefaults] setObject: @(resultData.global.lessReadSeconds) forKey:AppReadSeconds];

            //取出本地token
            NSString *localToken = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
            if (![localToken isEqualToString:resultData.user.token]) {
                //保存新的token
                [[NSUserDefaults standardUserDefaults] setObject:resultData.user.token forKey:AppToken];
                NSString * flag = @"wrong";
                [[NSUserDefaults standardUserDefaults] setObject:flag forKey:loginFlag];
                
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                //1、保存全局信息
                NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
                [NSKeyedArchiver archiveRootObject:resultData.global toFile:fileName]; //保存用户信息
                
              
                
                //1、保存个人信息
                fileName = [path stringByAppendingPathComponent:LocalUserDate];
                [NSKeyedArchiver archiveRootObject:nil toFile:fileName]; //保存用户信息
                
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
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       
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



-(void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

/**
 *  注册远程通知
 */
- (void)registRemoteNotification:(UIApplication *)application{
    if (IsIos8) { //iOS 8 remoteNotification
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeNewsstandContentAvailability;
        [application registerForRemoteNotificationTypes:type];
        
    }
}



/**
 *  内存警告
 *
 *  @param application <#application description#>
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    
}



/**
 *  定位
 */
- (void)test{
    self.mgr.delegate = self;
    self.mgr.desiredAccuracy = kCLLocationAccuracyKilometer;
    if (IsIos8) {
        
        [self.mgr requestAlwaysAuthorization];
    }else{
        [self.mgr startUpdatingLocation];
    }
}


/**
 *  定位定位代理方法
 *
 *  @param manager   <#manager description#>
 *  @param locations <#locations description#>
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * loc = [locations lastObject];
    NSString * lat = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    NSString * lg = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:lat forKey:DWLatitude]; //保存纬度
    [[NSUserDefaults standardUserDefaults] setObject:lg forKey:DWLongitude];//保存精度
    [self.mgr stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusNotDetermined) {
        
    }else if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.mgr startUpdatingLocation];
    }else{
        
    }
    
}




        
/**
 *  推送
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        detailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
       
        [self.currentVC.navigationController pushViewController:detail animated:YES];
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.taskId forKey:@"taskId"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:ReciveTaskId object:nil userInfo:userInfo];
    }else if (buttonIndex == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:ReLoad object:nil userInfo:nil];
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
