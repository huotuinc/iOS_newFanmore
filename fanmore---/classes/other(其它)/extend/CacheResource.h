//
//  CacheResource.h
//  minipartner
//
//  Created by Cai Jiang on 2/5/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheResource : NSObject

+(instancetype)cacheByTime:(NSString*)name time:(NSTimeInterval)time;

@property NSString* resourceName;

-(BOOL)acceptCache:(NSFileManager*)fm file:(NSString*)file;

@end
