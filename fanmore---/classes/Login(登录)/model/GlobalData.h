//
//  globalData.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  公共信息(globalDat

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject

/**流量充值最小值*/
@property(nonatomic,assign)int  amountToCheckout;

/**流量充值最小值*/
@property(nonatomic,strong) NSString * signMsg;

/**关于我们*/
@property(nonatomic,strong) NSString * aboutURL;

/**关于我们*/
@property(nonatomic,strong) NSString * serviceURL;

/**关于我们*/
@property(nonatomic,strong) NSString * serverURL;

/**帮助的连接*/
@property(nonatomic,strong) NSString * helpURL;

/**收入*/
@property(nonatomic,strong) NSArray * incomings;

/**职业*/
@property(nonatomic,strong) NSArray * career;

/**爱好*/
@property(nonatomic,strong) NSArray * favs;

/**最少阅读时间单位秒*/
@property(nonatomic,assign) int lessReadSeconds;
/**客服电话号码*/
@property(nonatomic,strong) NSString * customerServicePhone;
/**隐私策略*/
@property(nonatomic,strong) NSString * privacyPoliciesURL;
/**规则说明*/
@property(nonatomic,strong) NSString * ruleURL;
/**验证码是否支持语音播报*/
@property(nonatomic,assign)BOOL voiceSupported;
@end
