//
//  LoginResultData.h
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalData.h"
#import "updateData.h"
#import "userData.h"

@interface LoginResultData : NSObject
/**公共信息*/
@property(nonatomic,strong) GlobalData * global;
/**更新信息*/
@property(nonatomic,strong) updateData * update;
/**我的信息*/
@property(nonatomic,strong) userData * user;

@end
