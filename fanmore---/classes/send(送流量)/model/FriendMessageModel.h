//
//  FriendMessageModel.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/7/27.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendMessageModel : NSObject

@property (nonatomic, assign) NSInteger *fee;

@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) NSString *fromName;

@property (nonatomic, strong) NSString *fromPicUrl;

@property (nonatomic, assign) int fromSex;

//@property (nonatomic, assign) NSString *fromTele;

@end
