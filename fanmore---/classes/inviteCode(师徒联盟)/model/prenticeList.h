//
//  prenticeList.h
//  fanmore---
//
//  Created by lhb on 15/6/24.
//  Copyright (c) 2015年 HT. All rights reserved.
//  徒弟列表

#import <Foundation/Foundation.h>

@interface prenticeList : NSObject


@property(nonatomic,assign) int appid;

/**徒孙数量*/
@property(nonatomic,assign) int countOfApp;

/**注册时间*/
@property(nonatomic,assign) long long date;

/**贡献流量(M)*/
@property(nonatomic,assign) int m;

/**头像URL*/
@property(nonatomic,strong) NSString * picUrl;
/**展示的名称*/
@property(nonatomic,strong) NSString * showName;

@end
