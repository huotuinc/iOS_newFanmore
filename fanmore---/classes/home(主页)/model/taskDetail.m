//
//  taskDetail.m
//  fanmore---
//
//  Created by lhb on 15/6/11.
//  Copyright (c) 2015年 HT. All rights reserved.
//  答题任务详情

#import "taskDetail.h"
#import "answer.h"
@implementation taskDetail


- (NSDictionary *)objectClassInArray
{
    return @{@"answers":[answer class]};
}


@end
