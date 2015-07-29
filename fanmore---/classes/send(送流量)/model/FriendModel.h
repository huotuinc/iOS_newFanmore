//
//  FriendModel.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/15.
//  Copyright (c) 2015年 HT. All rights reserved.
//  送

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

//手机
@property (nonatomic, copy) NSString *phone;

//手机
@property (nonatomic, copy) NSString *name;

//1
@property (nonatomic, copy) NSString *image;

//2
@property (nonatomic, assign) int sex;

//3
@property (nonatomic, copy) NSString *flowLabel;

//4
@property (nonatomic,copy) NSString* originIdentify;

//yun so
@property (nonatomic, copy) NSString *operatorLabel;


@property (nonatomic, strong) NSString *fristLetter;

@property (nonatomic, strong) NSString *hanyupingyin;



/**在粉猫平台的剩余流量*/
@property(nonatomic,assign) CGFloat fanmoreBalance;

/**运行商的剩余流量*/
@property(nonatomic,assign) CGFloat  teleBalance;

/**该联系人电话号码所关联的粉猫用户名 通常是一个手机号码 如果没有找到则返回null*/
@property(nonatomic,strong) NSString * fanmoreUsername;

@end
