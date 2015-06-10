//
//  HomeCell.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation HomeCell

- (void)setImage:(NSString *)imageStr andNameLabel:(NSString *)name andTimeLabel:(NSString *)time andReceiveLabel:(NSString *)receive andJoinLabel:(NSString *)join andIntroduceLabel:(NSString *)introduce andGetImage:(int) selection
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:imageStr] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:nil completed:nil];
    self.nameLabel.text = name;
    self.timeLabel.text = time;
    self.receiveLabel.text = receive;
    
    self.joinLabel.text = join;
    self.introduceLabel.text = introduce;
    if (selection) {
        self.selection = selection;
        [self layoutIfNeeded];
    }
}

- (void)setSelection:(int)selection
{
    if (selection) {
        _selection = selection;
        [self layoutIfNeeded];
    }
}


-(void) layoutSubviews{
    [super layoutSubviews];
    if (self.selection == 0) {
        self.getImage.image = nil;
    }else if (self.selection == 1) {
        self.getImage.image = [UIImage imageNamed:@"received"];
    }else if (self.selection == 2) {
        self.getImage.image = [UIImage imageNamed:@"broughtOut"];
    }
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
