//
//  buyflay.h
//  fanmore---
//
//  Created by lhb on 15/6/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class flayModel;
@interface buyflay : NSObject




@property(nonatomic,strong) NSString * alipayNotifyUri;

@property(nonatomic,strong) NSString * alipayPartner;

@property(nonatomic,strong) NSString * mobileMsg;

@property(nonatomic,strong) NSArray * purchases;

@property(nonatomic,strong) NSString * wxpayAppId;

@property(nonatomic,strong) NSString * wxpayMerchantId;

@property(nonatomic,strong) NSString * wxpayNotifyUri;

@end
