//
//  DiscipleCell.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscipleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
@property (weak, nonatomic) IBOutlet UILabel *disciple;

- (void)setHeadImage:(NSString *)headUrl AndUserPhone:(NSString *) userPhone AndeTime:(NSString *) time AndFlow:(NSString *) flow AndDiscople:(NSString *) disciple;

@end
