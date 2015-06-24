//
//  InviteCodeViewController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  师徒联盟
#import <UIKit/UIKit.h>

@interface InviteCodeViewController : UIViewController

/**
 *  分享按钮
 *  师徒规则
 *  昨日流量
 *  徒弟总流量
 *  徒弟人数
 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *rulesLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *discipleContribution;
@property (weak, nonatomic) IBOutlet UILabel *discipleCount;


- (IBAction)shareAction:(UIButton *)sender;

@end
