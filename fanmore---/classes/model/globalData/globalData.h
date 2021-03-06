//
//  globalData.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  公共信息(globalDat

#import <Foundation/Foundation.h>

@interface globalData : NSObject

/**流量充值最小值*/
@property(nonatomic,strong)NSNumber * amountToCheckout;

/**流量充值最小值*/
@property(nonatomic,strong) NSString * signMsg;

/**关于我们*/
@property(nonatomic,strong) NSString * aboutURL;

/**帮助的连接*/
@property(nonatomic,strong) NSString * helpURL;

/**收入*/
@property(nonatomic,strong) NSArray * incomings;

/**职业*/
@property(nonatomic,strong) NSArray * career;

/**爱好*/
@property(nonatomic,strong) NSArray * favs;

@end
