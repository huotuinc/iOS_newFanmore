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



- (void)setMessage:(Message *)message{
    
    _message = message;
    //1外面view
    CGFloat viewX = 5;
    CGFloat viewy = 0;
    CGFloat viewW = ScreenWidth-30;
    
    //2里面的文本
    
    CGFloat conX = MessageMargin;
    CGFloat conY = MessageMargin;
    CGFloat conW = viewW;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
  
    CGRect conH = [message.context boundingRectWithSize:CGSizeMake(conW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
    self.contextF = CGRectMake(conX, conY, conH.size.width, conH.size.height+MessageMargin);
    
    
    CGFloat timeY = CGRectGetMaxY(self.contextF) + 2*MessageMargin;
    CGFloat timeW = viewW;
    CGFloat timeH = 20;
    CGFloat timeX = (ScreenWidth - timeW)*0.5;
    self.timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat viewH = CGRectGetMaxY(self.timeF);
    self.containView = CGRectMake(viewX, viewy, viewW, viewH);
    
    self.cellHeight = CGRectGetMaxY(self.containView)+10;
    
}

@end
