//
//  HAMineLoveCarDBOperator.m
//  安心汽车
//
//  Created by 罗海波 on 15/4/27.
//  Copyright (c) 2015年 ywkj. All rights reserved.
//  我的爱车数据库分装

#import "HAMineLoveCarDBOperator.h"
#import "FMDB.h"



//数据库实力对象
static FMDatabaseQueue * _dbqueue;;

@implementation HAMineLoveCarDBOperator

+ (void)initialize
{
    //获取沙河路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"taskID"];
   
    //创建数据库实力对象
    _dbqueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    
    [_dbqueue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"create table if not exists t_taskId (id integer primary key autoincrement,phonenumber text,taskid INTEGER);"];
        
    }];
}



/**
 * 插入数据库
 */
+ (BOOL)insertIntoFMDBWithSql:(NSString *)userName :(int) taskid{
    __block BOOL result = NO;
    [_dbqueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into t_taskId(phonenumber,taskid) values(%@,%d);",userName,taskid];
        result = [db executeUpdate:sql];
        
    }];
    return result;
}



/**
 * 查询某个车牌是否存在
 */
+ (BOOL)exqueryFMDBWithCondition:(NSString *)userName :(int) taskid{
    NSString * sqlStr = [NSString stringWithFormat:@"select * from t_taskId where phonenumber = '%@' and taskid = %d;",userName,taskid];
    __block BOOL have = NO;
  
    [_dbqueue inDatabase:^(FMDatabase *db) {
       FMResultSet * rs =  [db executeQuery:sqlStr];
        if ([rs next]) {
            have = YES;
        }
        [rs close];
    }];
    return have;
}



@end
