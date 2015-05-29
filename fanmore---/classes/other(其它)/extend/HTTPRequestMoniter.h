//
//  HTTPRequestMoniter.h
//  minipartner
//
//  Created by Cai Jiang on 1/7/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface HTTPRequestMoniter : NSObject

-(id)initWithASIHTTPRequest:(ASIHTTPRequest*)request;

-(void)cancel;

/**
 *  网络过程是否已经完成
 *  如果被取消 也认为是完成
 *
 *  @return <#return value description#>
 */
-(BOOL)isFinished;

-(BOOL)isCancelled;

@end
