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
    paramsOption[@"lat"] = @(lat_parame);
    paramsOption[@"lng"] = @(lng_parame);
    paramsOption[@"timestamp"] = @(1234567890);
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = @(APPLICATIONVERSION_parame);
    paramsOption[@"token"] = @"12321312321";
    paramsOption[@"imei"] = @"201505280940";
    paramsOption[@"cityCode"] = @"1372";
    paramsOption[@"cpaCode"] = @"default";
    [paramsOption addEntriesFromDictionary:params];
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
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
    paramsOption[@"lat"] = @(lat_parame);
    paramsOption[@"lng"] = @(lng_parame);
    paramsOption[@"timestamp"] = @(1234567890);
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = @(APPLICATIONVERSION_parame);
    paramsOption[@"token"] = @"12321312321";
    paramsOption[@"imei"] = @"201505280940";
    [paramsOption addEntriesFromDictionary:params];
    NSLog(@"ccccccc==%@",paramsOption);
    if (manager) {
        
        [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            success(success);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failure(error);
        }];
    }
}
@end
