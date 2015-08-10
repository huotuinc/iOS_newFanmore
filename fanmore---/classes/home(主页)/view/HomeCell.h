//
//  HomeCell.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeCell : UITableViewCell


/**
 *  showImage 图片
 *  nameLabel 名字
 *  timeLabel 时间
 *  receiveLabel 可领取的流量
 *  joinLabel 参与人数
 *  introduceLabel 店铺简介
 *  getImage 领取标识图片
 *  topImage 置顶标签
 */
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *getImage;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

/**
 *  selection 右下角领取状态标签：0：没选择 1:已领取 2:已领完
 */
@property (assign, nonatomic) int selection;


- (void)setImage:(NSString *)imageStr andNameLabel:(NSString *)name andTimeLabel:(NSString *) time andReceiveLabel:(NSString *) receiveLabel andJoinLabel:(NSString *) join andIntroduceLabel:(NSString *) introduce andGetImage:(int) selection andTopImage:(int) topImage;

- (void)setGetimageWithSection: (int) selection;

- (void)setSelection:(int)selection;

@end
