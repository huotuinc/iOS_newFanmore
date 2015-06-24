//
//  prenticeList.h
//  fanmore---
//
//  Created by lhb on 15/6/24.
//  Copyright (c) 2015年 HT. All rights reserved.
//  徒弟列表

#import <Foundation/Foundation.h>

@interface prenticeList : NSObject

/*
private java.lang.Number 	appid
private java.lang.Number 	countOfApp
徒孙数量
private java.util.Date 	date
注册时间
private java.lang.Number 	m
贡献流量(M)
private java.lang.String 	picUrl
头像URL
private java.lang.String 	showName
展示的名称
*/

@property(nonatomic,assign) int appid;

/**徒孙数量*/
@property(nonatomic,assign) int countOfApp;

/**注册时间*/
@property(nonatomic,assign) int date;

/**贡献流量(M)*/
@property(nonatomic,assign) int m;

/**头像URL*/
@property(nonatomic,strong) NSString * picUrl;
/**展示的名称*/
@property(nonatomic,strong) NSString * showName;

@end
