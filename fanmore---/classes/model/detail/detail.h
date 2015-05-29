//
//  detail.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detail : NSObject


@property(nonatomic,strong) NSNumber * detailId;
/**标题*/
@property(nonatomic,strong) NSString * title;
/**变化值，负数为减少 比如兑换*/
@property(nonatomic,strong) NSNumber * vary;
/**时间*/
@property(nonatomic,strong) NSString * data;

@end
