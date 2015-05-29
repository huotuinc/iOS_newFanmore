//
//  NSString+MP.m
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "NSString+MP.h"
#import "ASIDownloadCache.h"

@implementation NSString (MP)

-(BOOL)isUserName{
//    NSError* error;
//    NSRegularExpression* exp = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z]{1}[A-Za-z0-9_@.]{2,19}$" options:0 error:&error];
//    NSTextCheckingResult* result = [exp firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSString *regex = @"^[0-9]{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
//    return [self isMatchedByRegex:@"^[A-Za-z]{1}[A-Za-z0-9_@.]{2,19}$"];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isPassword{
//    return self.length>=6;
    NSString *regex = @"^.{6,12}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//
//    //    return [self isMatchedByRegex:@"^[A-Za-z]{1}[A-Za-z0-9_@.]{2,19}$"];
    return [predicate evaluateWithObject:self];
////    return [self isMatchedByRegex:@"^.{6,12}$"];
}

-(NSString*)parentPath{
    NSArray* paths = [self $split:@"/"];
    NSRange range = NSMakeRange(0, [paths count]-1);
    NSArray* newpaths = [paths subarrayWithRange:range];
    return [newpaths $join:@"/"];
}

-(NSString*)makeSureParentDirectoryExisting{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* path = [self parentPath];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:Nil error:Nil];
    }
    return self;
}

// 目录结构
// /httpCache
// /

-(HTTPRequestMoniter*)downloadImage:(void (^)(UIImage* image,NSError* error))handler asyn:(BOOL)asyn{
    return [self downloadImage:handler asyn:asyn resource:nil];
}

-(HTTPRequestMoniter*)downloadImage:(void (^)(UIImage* image,NSError* error))handler asyn:(BOOL)asyn resource:(CacheResource*)resource{
    
    NSString* resoucesHome =  [[$ documentPath]stringByAppendingPathComponent:@"resources"];
//    self.httpCache = [[ASIDownloadCache alloc] init];
//    [self.httpCache setStoragePath:[[$ documentPath]stringByAppendingPathComponent:@"httpCache"]];
    
    if (resource!=Nil) {
        NSFileManager* fm = [NSFileManager defaultManager];
        NSString* path = [resoucesHome stringByAppendingPathComponent:resource.resourceName];
        if ([resource acceptCache:fm file:path]) {
            handler([UIImage imageWithData:[fm contentsAtPath:path]],nil);
            return nil;
        }
    }
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self]];
    HTTPRequestMoniter* moniter = [[HTTPRequestMoniter alloc]initWithASIHTTPRequest:request];
    __weak HTTPRequestMoniter* wmontier = moniter;
    __weak ASIHTTPRequest* wrequest = request;
    
    ASIDownloadCache* httpCache = [ASIDownloadCache sharedCache];
    [httpCache setStoragePath:[[$ documentPath]stringByAppendingPathComponent:@"httpCache"]];
    
    [request setDownloadCache:httpCache];
    
//    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setSecondsToCache:60*60*24*30]; // Cache for 30 days
    
    [request setCompletionBlock:^{
        if ([wmontier isCancelled]) {
            return;
        }
        UIImage* image = [UIImage imageWithData:[wrequest responseData]];
        if (resource!=nil) {
            [[wrequest responseData]writeToFile:[[resoucesHome stringByAppendingPathComponent:resource.resourceName] makeSureParentDirectoryExisting] atomically:YES];
        }
        handler(image,nil);
    }];
    [request setFailedBlock:^{
        if ([wmontier isCancelled]) {
            return;
        }
        handler(nil,[wrequest error]);
    }];
    if (asyn) {
        [request startAsynchronous];
    } else {
        [request startSynchronous];
    }
    return moniter;
}

@end
