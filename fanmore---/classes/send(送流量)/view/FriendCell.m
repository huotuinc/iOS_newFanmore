//
//  FriendCell.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/15.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (void)setHeadImage:(UIImage *)headImage AndUserPhone:(NSString *)userPhone AndUserName:(NSString *) userName AndSex:(int) sex AndFlow:(NSString *)flot AndOperator:(NSString *)operatorStr {
    [self.headImage setBackgroundImage:headImage forState:UIControlStateNormal];
    self.userPhone.text = userPhone;
    self.userName.text = userName;
    if (sex) {
        
    }else {
        
    }
    self.flowLabel.text = flot;
    self.operatorLabel.text = operatorStr;
}

- (void)setUserName:(NSString *)userName AndUserPhone:(NSString *)userPhone {
    self.userName.text = userName;
    self.userPhone.text = userPhone;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
