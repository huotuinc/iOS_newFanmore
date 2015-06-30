//
//  ForeshowTableViewCell.m
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ForeshowTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MJExtension.h"
#import "taskData.h"

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


/**已上线标签*/
@property (weak, nonatomic) IBOutlet UIImageView *onlineImage;

/**
 *  已经设置提醒
 */


/**提醒按钮点击*/
- (IBAction)timeButtonClick:(id)sender;

@end


@implementation ForeshowTableViewCell





/**
 *  设置
 *
 *  @param imageStr  <#imageStr description#>
 *  @param name      <#name description#>
 *  @param time      <#time description#>
 *  @param FlayLabel <#FlayLabel description#>
 *  @param Content   <#Content description#>
 */
- (void)setImage:(NSString *)imageStr andNameLabel:(NSString *)name andTimeLabel:(NSString *)times andFlayLabel:(NSString *)FlayLabel andContentLabel:(NSString *)Content andOnlineImage:(BOOL)isOnline{

    NSURL * imageUrl = [NSURL URLWithString:imageStr];
    //1设置今日预告图片
    [self.iconView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"mrtou_h"] options:SDWebImageRetryFailed];
    self.title.text = name;
    self.flowlable.text = [NSString stringWithFormat:@"免费领取%@M",FlayLabel];
    self.contextLable.text = Content;
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:[times doubleValue]/1000];
    NSDate * now = [NSDate date];
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    NSString * publishtime = [formatter stringFromDate:ptime];
    self.timeLable.text = [NSString stringWithFormat:@"%@",publishtime];
    
    NSComparisonResult comper = [now compare:ptime];
    NSLog(@"%ld",(long)comper);
    

    if ((long)comper < 0) {
        self.onlineImage.hidden = YES;
    }else {
        self.onlineImage.hidden = NO;
    }
   
    self.timeButton.hidden = !self.onlineImage.hidden;
    
//    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    if (array.count > 0) {
//        for (int i = 0; i < array.count; i++) {
//            UILocalNotification *loa = [array objectAtIndex:i];
//            NSDictionary *userInfo = loa.userInfo;
//            NSNumber *obj = userInfo[@"key"];
//            int mytag = [obj intValue];
//            if (self.task.taskId == mytag) {
//                [self timeButtonSetBule];
//                break;
//            }
//            [self timeButtonWite];
//        }
//    }
 
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self timeButtonWite];
    
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            UILocalNotification *loa = [array objectAtIndex:i];
            NSDictionary *userInfo = loa.userInfo;
            NSNumber *obj = userInfo[@"key"];
            int mytag = [obj intValue];
            if (self.task.taskId == mytag) {
                [self timeButtonSetBule];
                
                break;
            }
        }
    }
}

//设置取消提醒
- (void)timeButtonSetBule {
    self.timeButton.layer.cornerRadius = 5;
    self.timeButton.layer.borderWidth = 1;
    self.timeButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.timeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.timeButton setTitle:@"取消提醒" forState:UIControlStateNormal];
}

//设置提醒
- (void)timeButtonWite {
    self.timeButton.layer.cornerRadius = 5;
    self.timeButton.layer.borderWidth = 1;
    self.timeButton.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
    [self.timeButton setTitleColor:[UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [self.timeButton setTitle:@"设置提醒" forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)timeButtonClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ForeshowTableViewCellSetTimeAlert:andTask:)]) {
        
        [self.delegate ForeshowTableViewCellSetTimeAlert:self andTask:self.task];
        
    }
    if (!self.isWarning) {
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        if (notification != nil) {
            NSDate *now=[NSDate new];
            notification.fireDate = [now dateByAddingTimeInterval:10];
            //([self.task.publishDate doubleValue] /1000.0) - [now timeIntervalSince1970]
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber += 1;
            notification.alertBody = @"任务答题将要开始";
            
            notification.userInfo = @{@"id":@(self.task.taskId),
                                      @"key":[NSNumber numberWithInt:self.task.taskId],
                                      @"titel":self.task.title,
                                      @"type":@(self.task.type),
                                      @"detailUrl":self.task.contextURL,
                                      @"backTime":@(self.task.backTime),
                                      @"flay":@(self.task.maxBonus),
                                      @"shareUrl":self.task.shareURL,
                                      @"pictureUrl":self.task.pictureURL,
                                      @"taskFailed":@(self.task.taskFailed),
                                      @"reward":@(self.task.reward)};
            
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            self.isWarning = !self.isWarning;
            [MBProgressHUD showSuccess:@"提醒设置成功"];
            
            [self timeButtonSetBule];
            
        }
    }else {
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if (array.count > 0) {
            for (int i = 0; i < array.count; i++) {
                UILocalNotification *loa = [array objectAtIndex:i];
                NSDictionary *userInfo = loa.userInfo;
                NSNumber *obj = userInfo[@"key"];
                int mytag = [obj intValue];
                if (self.task.taskId == mytag) {
//                    loa.applicationIconBadgeNumber = 0;
                    [[UIApplication sharedApplication] cancelLocalNotification:loa];
                    [MBProgressHUD showSuccess:@"已取消提醒"];
                    self.isWarning = !self.isWarning;
                    
                    [self timeButtonWite];
                    
                    break;
                }
            }
        }
    }

}



@end
