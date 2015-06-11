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

@property(nonatomic,assign) CGRect  containView;

@property(nonatomic,assign) CGRect  contextF;

@property(nonatomic,assign) CGRect  timeF;

@property(nonatomic,assign) CGFloat  cellHeight;

@end
