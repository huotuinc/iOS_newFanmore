//
//  FriendCell.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/15.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *fanmoreImage;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;

- (void)setHeadImage:(UIImage *)headImage AndUserPhone:(NSString *)userPhone AndUserName:(NSString *) userName AndSex:(int) sex AndFlow:(NSString *)flot AndOperator:(NSString *)operatorStr ;

@end
