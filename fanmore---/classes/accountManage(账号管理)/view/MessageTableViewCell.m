//
//  MessageTableViewCell.m
//  fanmore---
//
//  Created by lhb on 15/6/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setMessage:(Message *)message{
    
    _message = message;
}




- (void)setFrame:(CGRect)frame{
    frame.size.width -= 20;
    frame.origin.x = 10;
    [super setFrame:frame];
}
@end
