//
//  SendController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendController : UIViewController

@property (strong, nonatomic) NSArray *personArray;

@property (strong, nonatomic) NSMutableArray *searchArray;

- (void)ressetSearch;

- (void)handleSearchForTeam:(NSString *) secrchString;

@end
