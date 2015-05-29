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




+ (void)loginRequestGet:(NSString *)urlStr parame:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    if (manager) {
        
        [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            success(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failure(error);
        }];
    }
}


+ (void)loginRequestPost:(NSString *)urlStr parame:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    if (manager) {
        
        [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            success(success);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failure(error);
        }];
    }
}
@end
