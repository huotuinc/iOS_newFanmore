//
//  taskData.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  任务数据(taskData)

#import "taskData.h"

@implementation taskData




/**
 *  重写时间转化转换方法
 *
 *  @return <#return value description#>
 */
- (NSString *)turnTime{
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:[(_publishDate) doubleValue]/1000.0];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    return publishtime;

}
@end
