//
//  BPCell.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *flow;

- (void)setTitleName:(NSString *)titleName AndTime:(NSString *) tiem AndFlow:(NSString *) flow;

@end
