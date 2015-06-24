//
//  RequestTasks.m
//  fanmore---
//
//  Created by lhb on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "RequestTasks.h"
@implementation RequestTasks






+ (void)loginTasks:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    
    if (/* DISABLES CODE */ (YES)) {//先从数据库里面获取数据
        
    }else{//网络请求
        
        AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
        paramsOption[@"appKey"] = APPKEY;
        params[@"appSecret"] = HuoToAppSecret;
        NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
        NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
        params[@"lat"] = lat?lat:@(0.0);
        params[@"lng"] = lng?lng:@(0.0);;
        paramsOption[@"timestamp"] = apptimesSince1970;
        paramsOption[@"operation"] = OPERATION_parame;
        paramsOption[@"version"] =[NSString stringWithFormat:@"%@",AppVersion];
        NSString * token = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
        paramsOption[@"token"] = token?token:@"";
        paramsOption[@"imei"] = DeviceNo;
        paramsOption[@"cityCode"] = @"123";
        paramsOption[@"cpaCode"] = @"default";
        if (params != nil) {
            [paramsOption addEntriesFromDictionary:params];
        }
        paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
        [paramsOption removeObjectForKey:@"appSecret"];
        NSLog(@"网络请求参数parame%@",paramsOption);
        
        [manager GET:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    
}


@end
