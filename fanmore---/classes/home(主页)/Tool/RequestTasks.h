//
//  RequestTasks.h
//  fanmore---
//
//  Created by lhb on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestTasks : NSObject



/*获取首页数据*/
+ (void)loginTasks:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
