//
//  HobbyController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HobbyController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//用户的爱好勾选
@property (strong, nonatomic) NSString *userHobby;

@end
