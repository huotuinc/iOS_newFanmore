//
//  NSMutableDictionary+CJ.m
//  minipartner
//
//  Created by Cai Jiang on 3/19/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "NSMutableDictionary+CJ.h"

@implementation NSMutableDictionary (CJ)

-(NSMutableArray*)arrayInDict:(NSString *)name{
    NSMutableArray* array = self[name];
    if (array) {
        return array;
    }
    self[name] = $marrnew;
    return self[name];
}

-(NSMutableDictionary*)dictInDict:(NSString *)name{
    NSMutableDictionary* dict = self[name];
    if (dict) {
        return dict;
    }
    self[name] = $mdictnew;
    return self[name];
}

@end
