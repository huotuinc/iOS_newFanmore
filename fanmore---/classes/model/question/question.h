//
//  question.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface question : NSObject

@property(nonatomic,strong) NSNumber * qid;
/**问题*/
@property(nonatomic,strong) NSString * context;

@property(nonatomic,strong) NSNumber * answers;

@end
