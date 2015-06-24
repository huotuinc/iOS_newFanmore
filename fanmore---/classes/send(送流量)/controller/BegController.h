//
//  BegController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BegController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *trafficField;
@property (weak, nonatomic) IBOutlet UIButton *userHeadBtu;
@property (weak, nonatomic) IBOutlet UIButton *friendHeadBtu;
@property (weak, nonatomic) IBOutlet UILabel *userFlow;
@property (weak, nonatomic) IBOutlet UILabel *friendPhone;
@property (weak, nonatomic) IBOutlet UITextField *flowField;
- (IBAction)sendFlow:(UIButton *)sender;
- (IBAction)begFlow:(UIButton *)sender;

@end
