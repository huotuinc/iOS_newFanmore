//
//  BPCell.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "BPCell.h"

@implementation BPCell

- (void)setTitleName:(NSString *)titleName AndTime:(NSString *) tiem AndFlow:(NSString *) flow
{
    self.titleName.text = titleName;
    self.time.text = tiem;
    self.flow.text = flow;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
