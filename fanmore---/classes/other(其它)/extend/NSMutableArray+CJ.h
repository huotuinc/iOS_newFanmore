//
//  NSMutableArray+CJ.h
//  minipartner
//
//  Created by Cai Jiang on 4/1/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (CJ)

-(void)addObjectsFromArray:(NSArray *)otherArray uniquely:(SEL)sel;
-(void)removeObject:(id)obj uniquely:(SEL)sel;

@end
