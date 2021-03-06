//
//  UserLoginTool.h
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginTool : NSObject

/*账户网络请求Get*/
+ (void)loginRequestGet:(NSString *)urlStr parame:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)loginRequestPost:(NSString *)urlStr parame:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
