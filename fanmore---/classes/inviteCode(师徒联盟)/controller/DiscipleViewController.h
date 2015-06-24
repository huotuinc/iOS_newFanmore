//
//  DiscipleViewController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//  徒弟列表

#import <UIKit/UIKit.h>

@interface DiscipleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
