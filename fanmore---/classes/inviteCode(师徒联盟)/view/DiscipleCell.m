//
//  DiscipleCell.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//
#import <SDWebImageManager.h>
#import "DiscipleCell.h"

@implementation DiscipleCell

- (void)setHeadImage:(NSString *)headUrl AndUserPhone:(NSString *) userPhone AndeTime:(NSString *) time AndFlow:(NSString *) flow AndDiscople:(NSString *) disciple {
    
    NSURL *url = [NSURL URLWithString:headUrl];
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (error == nil) {
            [self.headImage setBackgroundImage:image forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:image forState:UIControlStateHighlighted];
        }
        
    }];
    
    self.userPhone.text = userPhone;
    self.timeLabel.text = time;
    self.flowLabel.text = flow;
    self.disciple.text = disciple;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
