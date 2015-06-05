//
//  userData.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  我的信息

#import "userData.h"
#import "twoOption.h"



@interface userData ()<NSCoding>


@end

@implementation userData


- (NSDictionary *)objectClassInArray
{
    return @{@"incomings":[twoOption class],@"career":[twoOption class],@"favs":[twoOption class]};
}

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
