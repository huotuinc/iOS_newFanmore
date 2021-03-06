//
//  AppDelegate.h
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//  辅导费

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate,NSLayoutManagerDelegate,LoginViewDelegate>

@property (strong, nonatomic) UIWindow *window;


//三个界面
@property (retain, nonatomic) UINavigationController *centerViewController;
@property (retain, nonatomic) IIViewDeckController* deckController;


//当前控制器
@property (nonatomic, strong) UIViewController *currentVC;


//yes 去 no 不去 去任务详情
@property (nonatomic, assign) BOOL goDetail;

//yes 有 no 无
@property (nonatomic, assign) BOOL getMessage;

/**题目id**/
@property(nonatomic, strong) NSString *taskId;

/**题目名字**/
@property (nonatomic, strong) NSString *titleString;

//用于好友请求消息提醒
@property(nonatomic, assign) BOOL getFriendBeg;

//点击求流量推送进APP
@property(nonatomic, assign) BOOL firstFriendBeg;

//好友送流量
@property(nonatomic, assign) BOOL getSendMes;

@end

