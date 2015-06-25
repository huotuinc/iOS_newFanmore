//
//  flayModel.h
//  fanmore---
//
//  Created by lhb on 15/6/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  流量

#import <Foundation/Foundation.h>

@interface flayModel : NSObject
/**流量单位*/
@property(nonatomic,assign) int m;
/**购买的id号*/
@property(nonatomic,assign) CGFloat price;
@property(nonatomic,strong) NSString *msg;
@property(nonatomic,assign) int purchaseid;
@end
