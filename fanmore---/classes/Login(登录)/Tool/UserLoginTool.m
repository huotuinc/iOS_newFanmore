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
    params[@"appSecret"] = HuoToAppSecret;
    
    NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
    NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
    params[@"lat"] = lat?lat:@(0.0);
    params[@"lng"] = lng?lng:@(0.0);;
    paramsOption[@"timestamp"] = apptimesSince1970;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] =[NSString stringWithFormat:@"%f",AppVersion];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:AppToken];
    paramsOption[@"token"] = token?token:@"";
    paramsOption[@"imei"] = DeviceNo;
    paramsOption[@"cityCode"] = @"123";
    paramsOption[@"cpaCode"] = @"default";
    [paramsOption addEntriesFromDictionary:params];
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    [paramsOption removeObjectForKey:@"appSecret"];
    NSLog(@"parame%@",paramsOption);
    [manager GET:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (responseObject) {
           success(responseObject); 
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
}


+ (void)loginRequestPost:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"appKey"] = APPKEY;
    params[@"appSecret"] = HuoToAppSecret;
    params[@"lat"] = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude]?[[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude]:@(1);
    params[@"lng"] = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude]?[[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude]:@(2);
    paramsOption[@"timestamp"] = @(1234567890);
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = @(AppVersion);
    paramsOption[@"token"] = @"12321312321";
    paramsOption[@"imei"] = @"201505280940";
    paramsOption[@"cityCode"] = @"1372";
    paramsOption[@"cpaCode"] = @"default";
    [paramsOption addEntriesFromDictionary:params];
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    [paramsOption removeObjectForKey:@"appSecret"];
    NSLog(@"parame%@",paramsOption);
    if (manager) {
        [manager POST:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(success);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failure(error);
        }];
    }
}
@end
