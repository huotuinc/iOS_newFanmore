 //
//  AppDelegate.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//  adasd

#import "AppDelegate.h"
#import "MobClick.h"
#import <INTULocationManager.h>//定位
#import "LoginResultData.h"
#import "MenuViewController.h"
#import "detailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "TrafficShowController.h"
//#import "WeiboApi.h"
#import "WeiboSDK.h"
//#import <RennSDK/RennSDK.h>
#import <AlipaySDK/AlipaySDK.h>  //支付宝接入头文件
#import "LWNewFeatureController.h"
#import <CoreLocation/CoreLocation.h> //定位
#import "NSData+NSDataDeal.h"




#define WeiXinPayId @"wxaeda2d5603b12302"


@interface AppDelegate () <CLLocationManagerDelegate,WXApiDelegate>

@property(nonatomic,strong) CLLocationManager *mgr;

//是app直接进入
@property (nonatomic, assign) BOOL isLauching;


/**apns*/
@property(nonatomic,strong) NSString * deviceToken;

//是否已有通知显示
@property(nonatomic, assign) BOOL isShowed;

//存储通知信息
@property(nonatomic, strong) NSMutableArray *notifationArray;



@end

@implementation AppDelegate

static NSString *message = @"有一条新消息";

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

    //进行初始化借口调用
    [self setupInit];
    
    //版本新特性
    NSString * appVersion = [[NSUserDefaults standardUserDefaults] stringForKey:LocalAppVersion];
    if (appVersion) {
        
        if ([appVersion isEqualToString:AppVersion]) {//相等
            RootViewController * roots = [[RootViewController alloc] init];
            self.window.rootViewController = roots;
            [self.window makeKeyAndVisible];
            
        }else{//不相等
            [[NSUserDefaults standardUserDefaults] setObject:AppVersion forKey:LocalAppVersion];
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
    
    
    //初始化通知参数
    self.isShowed = NO;
    self.firstFriendBeg = NO;
    self.getSendMes = NO;
    self.getFriendBeg = NO;
    self.notifationArray = [NSMutableArray array];
    
    if (launchOptions) {
        
        NSNotification *dicLocal = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (dicLocal) {
            self.titleString = dicLocal.userInfo[@"title"];
            self.taskId = dicLocal.userInfo[@"id"];
            self.goDetail = YES;
        }
        
        NSDictionary *dicRemote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dicRemote) {
            if (IsIos8) {
                self.isLauching = YES;
                [self getRemoteNotifocationFristLauchWithUserInfo:dicRemote];
            }else {
              [self getRemoteNotifocationFristLauchWithUserInfo:dicRemote];
            }
        }
        
    }
    
    //APNS
    [self registRemoteNotification:application];
    
    return YES;
    

    
}


/**
 *  ios7 远程通知方法
 *
 *  @param application <#application description#>
 *  @param userInfo    <#userInfo description#>
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [self getRemoteNotificationWithUserInfo:userInfo];
    
}


/**     
 *  获取deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
   
    NSString * aa = [[deviceToken hexadecimalString] copy];
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
        
        self.titleString = notification.userInfo[@"title"];
        self.taskId = notification.userInfo[@"id"];
        UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你关注的%@活动开始了", self.titleString] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
        ac.tag = 101;
        [ac show];
    }
}


/**
 *  app 回调
 *
 *  @param application <#application description#>
 *  @param url         <#url description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}





/**
 *  支付宝支付成功返回
 *
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    NSLog(@"xxxxxxxxxx%@",url.host);
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
//                                                      NSLog(@"aliPays ----- result = %@",resultDic);
                                                      if([resultDic[@"resultStatus"] intValue] == 9000){
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:WeiXinPaySuccessPostNotification object:nil];
                                                      }
                                                     
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"aliPaysa ----- result = %@",resultDic);
//            [[NSNotificationCenter defaultCenter] postNotificationName:WeiXinPaySuccessPostNotification object:nil];
        }];
    }
    
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    
}


/**
 *  微信支付回调方法
 *
 *  @param resp <#resp description#>
 */
- (void)onResp:(BaseResp *)resp {
//    NSLog(@"xxxxxxxxxxxx");
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"aaaasssss支付成功");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WeiXinPaySuccessPostNotification object:nil];
                break;
            default:
//                NSLog(@"支付失败， retcode=%d",resp.errCode);
                break;
        }
    }
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
                //2、保存个人信息
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
        NSLog(@"error == init %@",error.description);
       
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
    
    [WXApi registerApp:WeiXinPayId withDescription:[NSString stringWithFormat:@"fanmore--%@",AppVersion]]; //像微信支付注册
    
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
    [ShareSDK connectWeChatTimelineWithAppId:@"wx8ba33b7341047b58"
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
- (void)locationManager:(CLLocationManager *)manager didUpdataLocations:(NSArray *)locations{
    
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
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self gotoDetailController];
        }
        self.isShowed = NO;
        [self showAlertView];
    }else if (alertView.tag == 102) {
        if (buttonIndex == 0) {
            [self gotoMessageCenter];
        }
    }
}

// 点击通知进入APP应用
- (void)getRemoteNotifocationFristLauchWithUserInfo:(NSDictionary *)userInfo {
    NSNumber *num = userInfo[@"type"];

    switch ([num intValue]) {
        case 1:
        {

            
            //送流量消息
            self.titleString = userInfo[@"aps"][@"alert"][@"title"];
            NSString *type = [NSString stringWithFormat:@"%@", userInfo[@"data"]];
            //本地流量进行修改
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            userData* user =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
            user.balance = [NSString stringWithFormat:@"%.1f", [user.balance doubleValue] + [type doubleValue]];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            self.getSendMes = YES;
            
            break;
        }
        case 2:
            self.getFriendBeg = YES;
            self.firstFriendBeg = YES;
            break;
        case 3:
            break;
        case 4:
        {
            //任务推送
            self.titleString = userInfo[@"aps"][@"alert"][@"title"];
            self.taskId =  userInfo[@"data"];
            self.goDetail = YES;
        }
            break;
        case 5:
        {
            //通知
            self.titleString = userInfo[@"aps"][@"alert"][@"title"];
            self.getMessage = YES;
        }
            break;
        case 6:
        {
            //消息
            UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:userInfo[@"aps"][@"alert"][@"title"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [ac show];
            
        }
            break;
            
        default:
            break;
    }
}


//远程通知方法iOS
- (void)getRemoteNotificationWithUserInfo:(NSDictionary *)userInfo {
    
    if (self.isLauching) {
        self.isLauching = NO;
        [self getRemoteNotifocationFristLauchWithUserInfo:userInfo];
    }else {
        NSNumber *num = userInfo[@"type"];
        switch ([num intValue]) {
            case 1:
            {
                //送流量消息
                self.titleString = userInfo[@"aps"][@"alert"][@"title"];
                
                NSString *type = [NSString stringWithFormat:@"%@", userInfo[@"data"]];
                
                //本地流量进行修改
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                userData* user =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
                user.balance = [NSString stringWithFormat:@"%.1f", [user.balance doubleValue] + [type doubleValue]];
                [NSKeyedArchiver archiveRootObject:user toFile:fileName];
                
                if ([self.currentVC isKindOfClass:[MenuViewController class]]) {
                    MenuViewController *menu  = (MenuViewController *)self.currentVC;
                    CGFloat userFlow = [user.balance doubleValue];
                    if (userFlow - (int)userFlow > 0) {
                        menu.flowLable.text = [NSString stringWithFormat:@"%.1fM",[user.balance doubleValue]];
                    }else {
                        menu.flowLable.text = [NSString stringWithFormat:@"%.0fM",[user.balance doubleValue]];
                    }
                    if (userFlow > 1024) {
                        menu.flowLable.text = [NSString stringWithFormat:@"%.3fG",[user.balance doubleValue] / 1024];
                    }
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:self.titleString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                
                [alert show];
                break;
            }
            case 2:
            {
                self.getFriendBeg = YES;
                if ([self.currentVC isKindOfClass:[TrafficShowController class]]) {
                    TrafficShowController *tra = (TrafficShowController *)self.currentVC;
                    tra.redCircle.hidden = NO;
                }
                break;
            }
            case 3:
                break;
            case 4:
            {
                //任务推送
                if (self.isShowed == NO) {
                    self.titleString = userInfo[@"aps"][@"alert"][@"title"];
                    self.taskId = userInfo[@"data"];
                    UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@活动开始了", self.titleString] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
                    ac.tag = 101;
                    
                    self.isShowed = YES;
                    [ac show];
                    
                }else {
                    [self.notifationArray addObject:userInfo];
                }
            }
                break;
            case 5:
            {
                //通知
                NSString *title = userInfo[@"aps"][@"alert"][@"title"];
                UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:@"去看看" otherButtonTitles:@"取消",nil];
                ac.tag = 102;
                [ac show];
            }
                break;
            case 6:
            {
                //消息
                self.titleString = userInfo[@"aps"][@"alert"][@"title"];
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:self.titleString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
                break;
            
            default:
                break;
        }
    }

}
//通知内容调用alert方法
- (void)showAlertView {
    if (self.notifationArray.count > 0) {
        NSDictionary *userInfo = self.notifationArray[0];
        self.titleString = userInfo[@"aps"][@"alert"][@"title"];
        self.taskId = userInfo[@"data"];
        [self.notifationArray removeObject:userInfo];
        UIAlertView * ac = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@活动开始了", self.titleString] delegate:self cancelButtonTitle:@"去抢流量" otherButtonTitles:@"知道了", nil];
        self.isShowed = YES;
        
        ac.tag = 101;
        
        [ac show];
    }
}


//当前控制器转跳方法
- (void)gotoDetailController {
    if ([self.currentVC isKindOfClass:[detailViewController class]]) {
        
        detailViewController *detail1 = (detailViewController *)self.currentVC;
        
        if (detail1.taskId == [self.taskId intValue]) {
        }else {
            UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            detailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
            detail.taskId = [self.taskId intValue];
            detail.ishaveget = NO;
            [self.currentVC.navigationController pushViewController:detail animated:YES];
        }
    }else {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        detailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detail.taskId = [self.taskId intValue];
        detail.ishaveget = NO;
        [self.currentVC.navigationController pushViewController:detail animated:YES];
    }
    
}

//去消息列表
- (void)gotoMessageCenter {
    //判断是否需要登入
    NSString * flag = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    if ([flag isEqualToString:@"wrong"]) {//如果没有登入要登入
        
        LoginViewController * loginVc = [[LoginViewController alloc] init];
        loginVc.delegate = self;
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self.currentVC presentViewController:na animated:YES completion:nil];
    }else {
        if (![self.currentVC isKindOfClass:[MCController class]]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MCController *massage = [storyboard instantiateViewControllerWithIdentifier:@"MCController"];
            [self.currentVC.navigationController pushViewController:massage animated:YES];
        }else {
            [(MCController *)self.currentVC getNewMoreData];
        }
        
    }

}




@end
