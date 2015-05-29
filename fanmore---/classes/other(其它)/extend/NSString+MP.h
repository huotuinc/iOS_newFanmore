//
//  NSString+MP.h
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequestMoniter.h"
#import "CacheResource.h"

@interface NSString (MP)

-(BOOL)isUserName;

-(BOOL)isPassword;

-(NSString*)parentPath;

-(NSString*)makeSureParentDirectoryExisting;

// 目录结构
// /httpCache
// /

-(HTTPRequestMoniter*)downloadImage:(void (^)(UIImage* image,NSError* error))handler asyn:(BOOL)asyn;

-(HTTPRequestMoniter*)downloadImage:(void (^)(UIImage* image,NSError* error))handler asyn:(BOOL)asyn resource:(CacheResource*)resource;

@end
