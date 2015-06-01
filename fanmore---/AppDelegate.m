//
//  AppDelegate.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
//#import <INTULocationManager.h>//定位
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    *友盟*
    [MobClick startWithAppkey:UMENGID reportPolicy:BATCH channelId:nil];
    [MobClick setCrashReportEnabled:YES];
//    *友盟注册*
    
    
    if ([INTULocationManager locationServicesState] == INTULocationServicesStateAvailable) {
        NSLog(@"定位服务可以用");
        if (IsIos8) {
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
    }
  
    
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appKey"] = APPKEY;
    params[@"lat"] = @(120.2);
    params[@"lng"] = @(13.3);
    params[@"timestamp"] = @(1234567890);
    params[@"operation"] = OPERATION_parame;
    params[@"version"] = @(APPLICATIONVERSION_parame);
    params[@"token"] = @"";
    params[@"imei"] = @"201505280940";
    params[@"cityCode"] = @"1372";
    params[@"sign"] = [NSDictionary asignWithMutableDictionary:params];
    params[@"cpaCode"] = @"default";
    //网络请求借口
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"init"];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
//        NSLog(@"success====%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"xxxxxxx=%@",error.description);
    }];
    
    //用户名和数据有数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:loginUserName] && [[NSUserDefaults standardUserDefaults] objectForKey:loginPassword]) {
        
        RootViewController * roots = [[RootViewController alloc] init];
        self.window.rootViewController = roots;
    }else{
        LoginViewController * login = [[LoginViewController alloc] init];
        UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = loginNav;
        
    }
    [self.window makeKeyAndVisible];
    return YES;
}
//添加滑动的手势
- (void)handleSwipes22:(UISwipeGestureRecognizer *)sender{
    [self.deckController toggleRightViewAnimated:YES];
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
