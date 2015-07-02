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


@end

