//
//  MessageFrame.m
//  fanmore---
//
//  Created by lhb on 15/6/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MessageFrame.h"
#import "Message.h"

#define MessageMargin 5

@implementation MessageFrame

+(instancetype)FrameWithMessage:(Message *)mes
{
    MessageFrame * frame = [[self alloc] init];
    frame.message = mes;
    return frame;
}

- (instancetype)initWithMessage:(Message *)mes
{
    return [MessageFrame FrameWithMessage:mes];
}


- (void)setMessage:(Message *)message
{
    //1、设置头像
    CGFloat contextX = MessageMargin;
    CGFloat contextY = MessageMargin;
    
    NSString * context = message.context;
//    nsmu
//    [context boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
    CGFloat contextW = 60;
    CGFloat contextH = 60;
}
@end
