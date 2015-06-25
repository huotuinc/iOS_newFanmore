//
//  MessageTableViewCell.m
//  fanmore---
//
//  Created by lhb on 15/6/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MessageTableViewCell.h"

#import "MessageFrame.h"
#import "Message.h"

@interface MessageTableViewCell ()


@property(nonatomic,strong) UIImageView * wView;
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
        
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.contentView.layer.cornerRadius = 2;
        self.contentView.layer.masksToBounds = YES;
        //1外部的view
        UIImageView * aview = [[UIImageView alloc] init];
        aview.layer.cornerRadius = 8;
        aview.layer.masksToBounds = YES;
        self.wView = aview;
        [self addSubview:aview];
        
        //2正文内容
        UILabel * contextLable = [[UILabel alloc] init];
        contextLable.numberOfLines = 0;
        self.contextLable = contextLable;
        contextLable.font = [UIFont systemFontOfSize:14];
//        contextLable.backgroundColor = [UIColor blueColor];
        self.contextLable.textAlignment = NSTextAlignmentCenter;
        [contextLable setTextColor:[UIColor blackColor]];
        [aview addSubview:contextLable];
        
        //3时间
        UILabel * timeLabel = [[UILabel alloc] init];
//        timeLabel.backgroundColor = [UIColor redColor];
        [timeLabel setTextColor:[UIColor blackColor]];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLable = timeLabel;
        [aview addSubview:timeLabel];
        
    }

    return self;
}


- (void)setMessageF:(MessageFrame *)messageF{
    
    _messageF = messageF;
    Message * mess = messageF.message;
    self.wView.frame = messageF.containView;
    self.contextLable.text = mess.context;
    self.contextLable.frame = messageF.contextF;
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:(mess.date/1000.0)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    self.timeLable.text = publishtime;
    self.timeLable.frame = messageF.timeF;
}


- (void)setFrame:(CGRect)frame{
    frame.size.width -= 20;
    frame.origin.x = 10;
    frame.size.height -=10;
    frame.origin.y +=10;
    [super setFrame:frame];
}
@end
