//
//  taskDetail.h
//  fanmore---
//
//  Created by lhb on 15/6/11.
//  Copyright (c) 2015年 HT. All rights reserved.
//  答题任务详情

#import <Foundation/Foundation.h>

@interface taskDetail : NSObject

/**问题编号*/
@property(nonatomic, assign) int qid;
/**问题编号*/
@property(nonatomic,copy)NSString * context;

/**问题编号*/
@property(nonatomic,copy)NSString * imageUrl;
/**问题编号*/
@property(nonatomic,copy)NSString * relexUrl;
/**问题编号*/
@property(nonatomic,copy)NSString * fieldName;

/**问题编号*/
@property(nonatomic,copy)NSString * fieldPattern;

/**问题编号*/
@property(nonatomic,assign)int  correntAid;

@property(nonatomic,strong) NSArray * answers;

@end
