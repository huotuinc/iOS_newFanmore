//
//  FriendMessageModel.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/7/27.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendMessageModel : NSObject

/**
 *  请求流量
 */
@property (nonatomic, strong) NSString *fee;

/**
 *  用户名（手机）
 */
@property (nonatomic, strong) NSString *from;
/**
 *  昵称
 */
@property (nonatomic, strong) NSString *fromName;

/**
 *  头像url
 */
@property (nonatomic, strong) NSString *fromPicUrl;
/**
 *  性别
 */
@property (nonatomic, assign) int fromSex;

//@property (nonatomic, assign) NSString *fromTele;

/**
 *  消息id
 */
@property (nonatomic, strong) NSString *infoId;

/**
 *  消息内容
 */
@property (nonatomic, strong) NSString *message;

/**
 *  <#Description#>
 */
@property (nonatomic, assign) long long detailOrder;

@end
