//
//  updateData.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface updateData : NSObject

@property(nonatomic,strong) NSString * version;
@property(nonatomic,strong) NSString * updateUrl;
@property(nonatomic,strong) NSString * tips;
@property(nonatomic,strong) NSNumber * updateStatus;


- (instancetype)initWithVersion:(NSString *)version updateUrl:(NSString *)updateUrl tips:(NSString *)tips updateStatus:(NSNumber *)updateStatus;

+ (instancetype)updateDataWithVersion:(NSString *)version updateUrl:(NSString *)updateUrl tips:(NSString *)tips updateStatus:(NSNumber *)updateStatus;

@end
