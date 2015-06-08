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

//- (void)encodeWithCoder:(NSCoder *)enCoder{
//    
//    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//        
//        [enCoder encodeObject:ivar.value forKey:ivar.propertyName];
//    }];
//}
//
//
//- (id)initWithCoder:(NSCoder *)decoder{
//    
//    if (self = [super init]) {
//        
//        [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//            
//            ivar.value = [decoder decodeObjectForKey:ivar.propertyName];
//        }];
//    }
//    
//    return self;
//}

@end
