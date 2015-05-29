//
//  NSError+MP.m
//  minipartner
//
//  Created by Cai Jiang on 2/4/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "NSError+MP.h"

@implementation NSError (MP)

- (NSString *)MPDescription{
    NSString* msg= [self localizedDescription];
    //A connection failtrue occurred
    //A connection failure occurred
    if ($eql(@"The request timed out",msg)) {
        return @"网络不佳，伙伴客正在继续努力加载";
    }
    if ([msg rangeOfString:@"connection failure occurred"].location!=NSNotFound) {
        return @"尚未接入网络，伙伴客有力难施";
    }
    return msg;
}

@end
