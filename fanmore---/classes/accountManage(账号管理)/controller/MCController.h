//
//  MCController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/7/3.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)getNewMoreData;

@end
