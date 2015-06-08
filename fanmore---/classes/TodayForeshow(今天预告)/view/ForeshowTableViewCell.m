//
//  ForeshowTableViewCell.m
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ForeshowTableViewCell.h"


@interface ForeshowTableViewCell()


/**咨询图片*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**流量的领取量*/
@property (weak, nonatomic) IBOutlet UILabel *flowlable;
/**质询正文*/
@property (weak, nonatomic) IBOutlet UILabel *contextLable;
/**咨询时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
/**提醒按钮*/
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

/**提醒按钮点击*/
- (IBAction)timeButtonClick:(id)sender;

@end


@implementation ForeshowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)timeButtonClick:(id)sender {
    
    
    NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    
    if ([self.delegate respondsToSelector:@selector(ForeshowTableViewCellSetTimeAlert:)]) {
        
        [self.delegate ForeshowTableViewCellSetTimeAlert:self];
        
    }
    
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        NSDate *now=[NSDate new];
        notification.fireDate = [now dateByAddingTimeInterval:5];
//        notification.fireDate = [NSDate dateWithTimeIntervalSince1970:];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"我是火焰之王";
        
        NSDictionary* info = [NSDictionary dictionaryWithObject:@"1121`2" forKey:@"good"];
        notification.userInfo = info;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
   
    
}
@end
