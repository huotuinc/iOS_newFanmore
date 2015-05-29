//
//  NSMutableDictionary+CJ.h
//  minipartner
//
//  Created by Cai Jiang on 3/19/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (CJ)

/**
 *  在reciver中建立name 有的话 即可返回
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
-(NSMutableDictionary*)dictInDict:(NSString*)name;

/**
 *  在reciver中建立name 有的话 即可返回
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
-(NSMutableArray*)arrayInDict:(NSString*)name;

@end
