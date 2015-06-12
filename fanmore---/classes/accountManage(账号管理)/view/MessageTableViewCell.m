//
//  MessageTableViewCell.m
//  fanmore---
//
//  Created by lhb on 15/6/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MessageTableViewCell.h"

#import "MessageFrame.h"

@interface MessageTableViewCell ()


@property(nonatomic,strong) UIView * wView;
@property(nonatomic,strong) UILabel * contextLable;
@property(nonatomic,strong) UILabel * timeLable;
@end
@implementation MessageTableViewCell


+ (instancetype) cellWithTableView:(UITableView *)tableView{
    
    static NSString * ID = @"dadadasdasda";
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //1外部的view
        UIView * view = [[UIView alloc] init];
        self.wView = view;
        [self addSubview:view];
        
        //2正文内容
        UILabel * contextLable = [[UILabel alloc] init];
        self.contextLable = contextLable;
        [view addSubview:contextLable];
        
        //3时间
        UILabel * timeLabel = [[UILabel alloc] init];
        self.timeLable = timeLabel;
        [view addSubview:timeLabel];
        
    }

    return self;
}


- (void)setMessageF:(MessageFrame *)messageF{
    
    _messageF = messageF;
    self.wView.frame = messageF.containView;
    self.contextLable.frame = messageF.contextF;
    self.timeLable.frame = messageF.timeF;
}


- (void)setFrame:(CGRect)frame{
    frame.size.width -= 20;
    frame.origin.x = 10;
    [super setFrame:frame];
}
@end
