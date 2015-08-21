//
//  ContactGroup.h
//  fanmore---
//
//  Created by lhb on 15/7/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//  联系人分组模型

#import <Foundation/Foundation.h>

@interface ContactGroup : NSObject

/**头部标题*/
@property(nonatomic,copy)NSString * firstLetter;

/**每组的联系人*/
@property(nonatomic,strong)NSMutableArray * friends;


@end
