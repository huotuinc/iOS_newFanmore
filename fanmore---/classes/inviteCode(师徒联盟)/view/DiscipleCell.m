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


- (void)setHeadImage:(NSString *)headUrl AndUserPhone:(NSString *) userPhone AndeTime:(long long) time AndFlow:(NSString *) flow AndDiscople:(NSString *) disciple {
    
    self.flowLabel.adjustsFontSizeToFitWidth = YES;
    NSURL *url = [NSURL URLWithString:headUrl];
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (error == nil) {
            [self.headImage setBackgroundImage:image forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:image forState:UIControlStateHighlighted];
        }
        
    }];
    
    self.userPhone.text = userPhone;
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:(time/1000.0)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    self.timeLabel.text = publishtime;
    self.flowLabel.text = [NSString stringWithFormat:@"贡献%@M",flow];
    self.disciple.text = [NSString stringWithFormat:@"徒孙%@人",disciple];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
