//
//  HTTPRequestMoniter.m
//  minipartner
//
//  Created by Cai Jiang on 1/7/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "HTTPRequestMoniter.h"

@interface HTTPRequestMoniter()

@property BOOL cancelled;
@property(weak) ASIHTTPRequest* asiRequest;

@end

@implementation HTTPRequestMoniter

-(id)initWithASIHTTPRequest:(ASIHTTPRequest*)request{
    self = [super init];
    self.asiRequest = request;
    return self;
}
-(void)cancel{
    self.cancelled = YES;
    if (self.asiRequest) {
        [self.asiRequest cancel];
    }
}

-(BOOL)isFinished{
    if (self.asiRequest) {
        return self.asiRequest.complete || [self.asiRequest isCancelled];
    }
    return YES;
}

-(BOOL)isCancelled{
    if (self.cancelled) {
        return YES;
    }
    return NO;
}

@end
