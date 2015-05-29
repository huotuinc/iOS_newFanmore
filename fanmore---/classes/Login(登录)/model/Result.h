//
//  Result.h
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResultData.h"

@interface Result : NSObject

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * resultCode;
@property(nonatomic,strong) LoginResultData * resultData;
@property(nonatomic,copy) NSString * tip;
@property(nonatomic,strong) NSString * description;
@end
