//
//  Message.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  消息(message)

#import <Foundation/Foundation.h>

@interface Message : NSObject

/**消息编号*/
@property(nonatomic,strong) NSNumber * messageid;
/**消息标题*/
@property(nonatomic,strong) NSString * title;
/**消息地址*/
@property(nonatomic,strong) NSString * url;
/**时间*/
@property(nonatomic,strong) NSString * date;
@end
