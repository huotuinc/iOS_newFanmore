//
//  HAMineLoveCarDBOperator.h
//  安心汽车
//
//  Created by 罗海波 on 15/4/27.
//  Copyright (c) 2015年 ywkj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HAMineLoveCarDBOperator : NSObject



/**
 * 插入数据库
 */
+ (BOOL)insertIntoFMDBWithSql:(NSString *)userName :(int) taskid;



/**
 * 查询某个车牌是否存在
 */
+ (BOOL)exqueryFMDBWithCondition:(NSString *)userName :(int) taskid;

@end
