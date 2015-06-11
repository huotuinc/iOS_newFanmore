//
//  MessageTableViewCell.h
//  fanmore---
//
//  Created by lhb on 15/6/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageFrame;

@interface MessageTableViewCell : UITableViewCell


@property(nonatomic,strong) MessageFrame * messageF;



+ (instancetype) cellWithTableView:(UITableView *)tableView;

@end
