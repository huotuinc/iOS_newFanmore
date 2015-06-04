//
//  userData.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  我的信息

#import <Foundation/Foundation.h>

@interface userData : NSObject
/**流量余额*/
@property(nonatomic,strong) NSNumber * balance;
/**用户头像连接*/
@property(nonatomic,strong) NSString * pictureURL;
/**邀请码*/
@property(nonatomic,strong) NSString * invCode;
/**签到*/
@property(nonatomic,strong) NSNumber * signInfo;
/**今日签到获取流量*/
@property(nonatomic,strong) NSNumber * signtoday;

/**姓名*/
@property(nonatomic,strong) NSString * name;
/**生日*/
@property(nonatomic,strong) NSString * birthDate;
/**电话*/
@property(nonatomic,strong) NSString * mobile;
/**职业索引*/
@property(nonatomic,strong) NSArray * career;
/**收入索引*/
@property(nonatomic,strong) NSArray * incoming;
/**爱好索引串  以逗号隔开*/
@property(nonatomic,strong) NSArray * favs;

/**区域*/
@property(nonatomic,strong) NSString * area;

/**注册时间*/
@property(nonatomic,strong) NSString * regDate;

/**无效类型 0:有效用户 1:手机无效(需要绑定手机)*/
@property(nonatomic,strong) NSNumber * invalidCode;

/**欢迎提示，包括积分转换信息，来宾转正信息*/
@property(nonatomic,strong) NSString * welcomeTip;

/**身份验证 服务端负责生成 负责验证；app端只需要保存 传递*/
@property(nonatomic,strong) NSString * token;

@end
