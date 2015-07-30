//
//  ContactGroup.m
//  fanmore---
//
//  Created by lhb on 15/7/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//  联系人分组模型

#import "ContactGroup.h"

@implementation ContactGroup


- (instancetype)init{
    if (self = [super init]) {
        
        _friends = [NSMutableArray array];
    }
    return self;
}
@end
