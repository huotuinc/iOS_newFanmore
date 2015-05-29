//
//  NSArray+CJ.m
//  minipartner
//
//  Created by Cai Jiang on 4/1/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "NSArray+CJ.h"

@implementation NSArray (CJ)

- (NSUInteger)indexOfObject:(id)anObject by:(SEL)sel{
    id realOne = [self sameAsObject:anObject by:sel];
    if (!realOne) {
        return NSNotFound;
    }
    return [self indexOfObject:realOne];
}

-(BOOL)isEqualToArray:(NSArray *)otherArray sel:(SEL)sel{
    if (!otherArray) {
        return  NO;
    }
    if (otherArray.count!=self.count) {
        return NO;
    }
    
    for (int i=0; i<self.count; i++) {
        id obj = self[i];
        if (![obj respondsToSelector:sel]) {
            return NO;
        }
        if(![obj performSelector:sel withObject:otherArray[i]]){
            return NO;
        }
    }
    return YES;
}

- (BOOL)containsObject:(id)anObject by:(SEL)sel{
    for (id obj in self) {
        if (![obj respondsToSelector:sel]) {
            return NO;
        }
        if ([obj performSelector:sel withObject:anObject])
            return YES;
    }
    return NO;
}

- (id)sameAsObject:(id)anObject by:(SEL)sel{
    for (id obj in self) {
        if (![obj respondsToSelector:sel]) {
            return nil;
        }
        if ([obj performSelector:sel withObject:anObject])
            return obj;
    }
    return nil;
}

@end
