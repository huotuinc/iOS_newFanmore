//
//  TaskDataCeach.m
//  fanmore---
//
//  Created by lhb on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//  本地缓存工具

#import "TaskDataCeach.h"
#import "taskData.h"

@implementation TaskDataCeach


//数据库实力对象
static FMDatabaseQueue * _dbqueue;;


+ (void)initialize
{
    //获取沙河路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:FanMoreDB];
    NSLog(@"%@",fileName);
    //创建数据库实力对象
    _dbqueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [_dbqueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists %@ (id integer primary key autoincrement,userName text,taskDate blob,taskId INTEGER);",TaskDataTable];
    }];
}


/**
 *  把认为甜入数据库
 *
 *  @param task <#task description#>
 */
+ (void)addTaskDataWithUserName:(NSString *)userName WithTask:(NSDictionary *)task{
    
   NSData * taskDate = [NSKeyedArchiver archivedDataWithRootObject:task];
    NSString * localuserName = [[NSUserDefaults standardUserDefaults] stringForKey:loginUserName];
   [_dbqueue inDatabase:^(FMDatabase *db) {
       
       [db executeUpdate:@"insert into '%@' (userName,taskDate,taskId) values('%@','%@','%@')",TaskDataTable,localuserName,taskDate,task[@"taskId"]];
   }];
}

/**
 *  把认为甜入数据库
 *
 *  @param task <#task description#>
 */
+ (void)addTaskDatasWithUserName:(NSString *)userName WithTask:(NSArray *)tasks{
    
    for (NSDictionary * task in tasks) {
        
        [self addTaskDataWithUserName:userName WithTask:task];
    }
}

/**
 *  获取一条任务
 *
 */
+ (taskData *)taskWithtaskId:(NSNumber *) taskid{
    
   __block NSData * date =  [[NSData alloc] init];
   __block NSString * localuserName = [[NSUserDefaults standardUserDefaults] stringForKey:loginUserName];
    [_dbqueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs =  [db executeQuery:@"select * from '%@' where userName = '%@' and  taskId = '%@';",TaskDataTable,localuserName,[taskid intValue]];
        if ([rs next]) {
           
            date  = [rs dataForColumn:@"taskDate"];
        }
        [rs close];
    }];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:date];
}


/**
 *  获取多条任务
 */
+ (NSMutableArray *)tasksWithtaskid:(NSNumber *)taskid andSize:(NSNumber *)size{
    int taskSize = [size intValue];
    NSMutableArray * tasks = [NSMutableArray array];
    for (int index = 0; index < taskSize; index++) {
        
        taskData * data = [self taskWithtaskId:[NSNumber numberWithInt:(taskSize - index)]];
        [tasks addObject:data];
    }
    return tasks;
}
@end
