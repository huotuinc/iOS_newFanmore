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
    
    //1外面view
    CGFloat viewX = 0;
    CGFloat viewy = 0;
    CGFloat viewW = ScreenWidth;
    
    //2里面的文本
    
    CGFloat conX = MessageMargin;
    CGFloat conY = MessageMargin;
    CGFloat conW = ScreenWidth - MessageMargin * 2;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    CGRect conH = [message.context boundingRectWithSize:CGSizeMake(conW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    self.contextF = CGRectMake(conX, conY, conH.size.width, conH.size.height);
    
    CGFloat timeX = conX;
    CGFloat timeY = CGRectGetMaxY(self.contextF) + MessageMargin;
    CGFloat timeW = conW;
    CGFloat timeH = 20;
    self.timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat viewH = CGRectGetMaxY(self.timeF);
    self.containView = CGRectMake(viewX, viewy, viewW, viewH);
    
    self.cellHeight = CGRectGetMaxY(self.containView);
    
}
@end
