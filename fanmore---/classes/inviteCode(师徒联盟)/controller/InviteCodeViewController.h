//
//  InviteCodeViewController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCodeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *myInviteLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  复制到剪贴板
 *
 *  @param sender <#sender description#>
 */
- (IBAction)copyAction:(UIButton *)sender;

@end
