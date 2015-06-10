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
    paramsOption[@"version"] =[NSString stringWithFormat:@"%f",AppVersion];
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
    
    NSLog(@"网络请求参数parame%@",paramsOption);
    [manager GET:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",responseObject);
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
    paramsOption[@"version"] = [NSString stringWithFormat:@"%f",AppVersion];
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
    NSLog(@"parame%@",paramsOption);
    [manager POST:urlStr parameters:paramsOption success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
  
}


//+ (void)toUploadingData:(NSString *)urlStr parame:(NSMutableDictionary *)params image:(UIImage *)image success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
//    
//    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
//    paramsOption[@"appKey"] = APPKEY;
//    params[@"appSecret"] = HuoToAppSecret;
//    NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
//    NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
//    paramsOption[@"lat"] = lat?lat:@(0.0);
//    paramsOption[@"lng"] = lng?lng:@(0.0);;
//    paramsOption[@"timestamp"] = apptimesSince1970;;
//    paramsOption[@"operation"] = OPERATION_parame;
//    paramsOption[@"version"] = [NSString stringWithFormat:@"%f",AppVersion];
//    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:AppToken];
//    paramsOption[@"token"] = token?token:@"";
//    paramsOption[@"imei"] = DeviceNo;
//    paramsOption[@"cityCode"] = @"1372";
//    paramsOption[@"cpaCode"] = @"default";
//    if (params != nil) { //传入参数不为空
//        [paramsOption addEntriesFromDictionary:params];
//    }
//    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
//    [paramsOption removeObjectForKey:@"appSecret"];
//    NSLog(@"parame%@",paramsOption);
//    
////    NSData * imageData = [NSData dataWithContentsOfFile:image];
////    [manager POST:urlStr parameters:paramsOption constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////        [formData appendPartWithFileData:<#(NSData *)#> name:<#(NSString *)#> fileName:@"iconView" mimeType:@"image/jpeg"]
////    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        
////        success(responseObject);
////        
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        failure(error);
////    }];
//}
@end
