//
//  MessageFrame.h
//  fanmore---
//
//  Created by lhb on 15/6/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Message;

@interface MessageFrame : NSObject

@property(nonatomic,strong) Message * message;

@property(nonatomic,assign) CGFloat contextF;

@property(nonatomic,assign) CGFloat timeF;


+(instancetype)FrameWithMessage:(Message *)mes;

- (instancetype)initWithMessage:(Message *)mes;


@end
