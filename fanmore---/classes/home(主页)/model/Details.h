//
//  Details.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/24.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Details : NSObject

/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  时间
 */
@property (nonatomic, assign) long long date;

//id
@property (nonatomic, assign) long detailId;

//变化值
@property (nonatomic, strong) NSNumber *vary;

@end
