//
//  TaskDataCeach.h
//  fanmore---
//
//  Created by lhb on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//  本地缓存工具

#import <Foundation/Foundation.h>

@class taskData;

@interface TaskDataCeach : NSObject


+ (void)addTaskDataWithUserName:(NSString *)userName WithTask:(NSDictionary *)task;

+ (void)addTaskDatasWithUserName:(NSString *)userName WithTask:(NSArray *)tasks;

+ (taskData *)taskWithtaskId:(NSNumber *) taskid;

+ (NSMutableArray *)tasksWithtaskid:(NSNumber *)taskid andSize:(NSNumber *)size;

@end
