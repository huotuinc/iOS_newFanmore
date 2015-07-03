//
//  AppDelegate.h
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//  辅导费

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate,NSLayoutManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


//三个界面
@property (retain, nonatomic) UINavigationController *centerViewController;
@property (retain, nonatomic) IIViewDeckController* deckController;


//当前控制器
@property (nonatomic, strong) UIViewController *currentVC;

//yes 去 no 不去 去消息中心
@property (nonatomic, assign) BOOL goMessage;

//yes 去 no 不去 去任务详情
@property (nonatomic, assign) BOOL goDetail;

//yes 有 no 无
@property (nonatomic, assign) BOOL getMessage;

/**题目id**/
@property(nonatomic, strong) NSNumber *taskId;

/**题目名字**/
@property (nonatomic, strong) NSString *titleString;


@end

