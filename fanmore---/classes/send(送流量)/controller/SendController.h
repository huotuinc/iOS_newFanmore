//
//  SendController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"


@interface SendController : UIViewController

@property (strong, nonatomic) NSMutableArray *personArray;

@property (strong, nonatomic) NSMutableArray *searchArray;

@property (strong, nonatomic) UITableView *ResultsTableView;

/**
 *  用于用户数据返回服务器
 */
@property (strong, nonatomic) NSMutableString *userPhone;


@end
