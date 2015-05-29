//
//  NSArray+CJ.h
//  minipartner
//
//  Created by Cai Jiang on 4/1/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CJ)

/**
 *  是否为一致的Array
 *
 *  @param otherArray <#otherArray description#>
 *  @param sel        检查唯一的SEL 唯一参数 另外一个obj
 *
 *  @return <#return value description#>
 */
-(BOOL)isEqualToArray:(NSArray *)otherArray sel:(SEL)sel;

/**
 *  是否包含指定obj
 *
 *  @param anObject <#anObject description#>
 *  @param sel      检查唯一的SEL 唯一参数 anObject
 *
 *  @return <#return value description#>
 */
- (BOOL)containsObject:(id)anObject by:(SEL)sel;

/**
 *  寻找跟输入obj一样的obj
 *
 *  @param anObject <#anObject description#>
 *  @param sel      检查唯一的SEL 唯一参数 anObject
 *
 *  @return <#return value description#>
 */
- (id)sameAsObject:(id)anObject by:(SEL)sel;

- (NSUInteger)indexOfObject:(id)anObject by:(SEL)sel;

@end
