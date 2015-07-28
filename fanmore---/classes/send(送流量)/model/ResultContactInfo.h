//
//  ResultContactInfo.h
//  fanmore---
//
//  Created by lhb on 15/7/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//  服务器返回的

#import <Foundation/Foundation.h>

@interface ResultContactInfo : NSObject

/**在粉猫平台的剩余流量*/
@property(nonatomic,assign) CGFloat fanmoreBalance;
/**头像URL*/
@property(nonatomic,strong) NSString * fanmorePicUrl;
/**在粉猫平台的剩余流量*/
@property(nonatomic,assign) int fanmoreSex;
/**运营商*/
@property(nonatomic,strong) NSString * fanmoreTele;
/**该联系人电话号码所关联的粉猫用户名 通常是一个手机号码 如果没有找到则返回null*/
@property(nonatomic,strong) NSString * fanmoreUsername;

/**用户提交的联系人唯一识别码*/
@property(nonatomic,strong) NSString * originIdentify;
/**用户提交的联系人电话号码*/
@property(nonatomic,strong) NSString * originMobile;

/**用户提交的联系人电话号码*/
@property(nonatomic,assign) CGFloat  teleBalance;

@end
