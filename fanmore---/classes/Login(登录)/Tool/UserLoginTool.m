//
//  UserLoginTool.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "UserLoginTool.h"


@interface UserLoginTool()

@end



@implementation UserLoginTool

+ (void)loginRequestGet:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"appKey"] = APPKEY;
    paramsOption[@"appSecret"] = HuoToAppSecret;
    NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
    NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
    paramsOption[@"lat"] = (lat?lat:@(40.0));
    paramsOption[@"lng"] = (lng?lng:@(116.0));
    paramsOption[@"timestamp"] = apptimesSince1970;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] =AppVersion;
    NSString * token = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
    paramsOption[@"token"] = token?token:@"";
    paramsOption[@"imei"] = DeviceNo;
    paramsOption[@"cityCode"] = @"1372";
    paramsOption[@"cpaCode"] = @"default";
    if (params != nil) { //传入参数不为空
       [paramsOption addEntriesFromDictionary:params];
    }
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    [paramsOption removeObjectForKey:@"appSecret"];
    
//    NSArray * parameaaa = [paramsOption allKeys];
//    NSMutableString * aaa = [[NSMutableString alloc] init];
//    
//    for (NSString * a in parameaaa) {
//        [aaa appendString:[NSString stringWithFormat:@"%@=%@&",a,[paramsOption objectForKey:a]]];
//    }
//    aaa = [aaa substringToIndex:(int)(aaa.length-1)];
//    NSLog(@"--------------------%@",aaa);
//    
//    NSLog(@"dasdasdas-------parame--get%@",paramsOption);
    
    [manager GET:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


+ (void)loginRequestPost:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"appKey"] = APPKEY;
    paramsOption[@"appSecret"] = HuoToAppSecret;
    NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
    NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
    paramsOption[@"lat"] = lat?lat:@(40.0);
    paramsOption[@"lng"] = lng?lng:@(116.0);;
    paramsOption[@"timestamp"] = apptimesSince1970;;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = AppVersion;
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:AppToken];
    paramsOption[@"token"] = token?token:@"";
    paramsOption[@"imei"] = DeviceNo;
    paramsOption[@"cityCode"] = @"1372";
    paramsOption[@"cpaCode"] = @"default";
    if (params != nil) { //传入参数不为空
        [paramsOption addEntriesFromDictionary:params];
    }
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    [paramsOption removeObjectForKey:@"appSecret"];
    NSArray * parameaaa = [paramsOption allKeys];
    NSMutableString * aaa = [[NSMutableString alloc] init];
    for (NSString * a in parameaaa) {
        [aaa appendString:[NSString stringWithFormat:@"%@=%@&",a,[paramsOption objectForKey:a]]];
    }
    [aaa substringToIndex:aaa.length];
//    NSLog(@"--------------------%@",aaa);
//    NSLog(@"xxxxxx-----网络请求get参数parame%@",paramsOption);
//    NSLog(@"网络请求－－－－post参数%@",paramsOption);
    [manager POST:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
}

@end
