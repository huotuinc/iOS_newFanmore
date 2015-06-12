//
//  globalData.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  公共信息(globalDat

#import "GlobalData.h"
#import "twoOption.h"

@interface GlobalData()<NSCoding>

@end
@implementation GlobalData

MJCodingImplementation

- (NSDictionary *)objectClassInArray
{
    return @{@"incomings":[twoOption class],@"career":[twoOption class],@"favs":[twoOption class]};
}

@end
