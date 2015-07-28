//
//  FriendModel.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/15.
//  Copyright (c) 2015年 HT. All rights reserved.
//  送

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *name;

//
@property (nonatomic, copy) UIImage *image;

//
@property (nonatomic, assign) int sex;

//
@property (nonatomic, copy) NSString *flowLabel;

//
@property (nonatomic,copy) NSString* originIdentify;


@property (nonatomic, copy) NSString *operatorLabel;

@property (nonatomic, strong) NSString *fristLetter;

@property (nonatomic, strong) NSString *hanyupingyin;

@end
