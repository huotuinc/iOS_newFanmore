//
//  BegController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface BegController : UIViewController

/**
 *  输入的流量
 */
@property (weak, nonatomic) IBOutlet UITextField *flowField;

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIButton *userHeadBtu;
@property (weak, nonatomic) IBOutlet UIButton *friendHeadBtu;

/**
 *  用户流量
 */
@property (weak, nonatomic) IBOutlet UILabel *userFlow;

/**
 *  好友手机
 */
@property (weak, nonatomic) IBOutlet UILabel *friendPhone;

/**
 *  发送
 */
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

/**
 *  求流量
 */
@property (weak, nonatomic) IBOutlet UIButton *begButton;

/**
 *  送流量
 *
 *  @param sender <#sender description#>
 */
- (IBAction)sendFlow:(UIButton *)sender;

/**
 *  求流量
 *
 *  @param sender <#sender description#>
 */
- (IBAction)begFlow:(UIButton *)sender;

/**
 *  用户模型
 */
@property (nonatomic, strong) FriendModel *model;

/**
 *  是否是粉猫用户
 */
@property (nonatomic, assign) BOOL isFanmoreUser;


@end
